{ pkgs }:

pkgs.writeShellApplication {
  name = "vault-login";

  runtimeInputs = with pkgs; [
    vault-bin
    jq
    git
    gnused
  ];

  text = ''
    # vault-login — fetch short-lived Vault DB credentials and paste them into
    # voipgrid/settings/secrets.txt, so you can then run the DB yourself with any
    # command, e.g.:
    #     DB=slave0 docker compose run --rm web ./manage shell_plus
    #
    # Usage:
    #   vault-login slave        # coredb read-mirror creds  (then use DB=slave0 / slave1)
    #   vault-login devdb        # devdb0 creds              (then use DB=devdb0)
    #   vault-login devdb0-ams   # a specific devdb server
    #
    # Requires: Spindle VPN up, "VoIPGRID DevDB Users" KeyHub group.

    target="''${1:-slave}"
    case "$target" in           # friendly shorthands
      slave) target=slave0 ;;
      devdb) target=devdb0 ;;
    esac

    # Short DB name -> Vault mount. slave*/coredb* are on the prod vault; the rest
    # are devdbs on the dev vault.
    declare -A mount=(
      [coredb0-ams]=coredb-production [coredb0-grq]=coredb-production
      [slave0]=coredb-production      [slave1]=coredb-production
      [devdb0-grq]=devdb0-grq-dev     [devdb0-ams]=devdb0-ams-dev  [devdb0-ede]=devdb0-ede-dev
      [devdb1-grq]=devdb1-grq-dev     [devdb1-ams]=devdb1-ams-dev
      [devdb0]=devdb0-grq-dev         [devdb1]=devdb0-ams-dev      [devdb3]=devdb0-ede-dev
    )
    database="''${mount[$target]:-}"
    if [ -z "$database" ]; then
      echo "vault-login: unknown target '$target'. Known: slave devdb ''${!mount[*]}" >&2
      exit 1
    fi

    if [ "$database" = coredb-production ]; then
      export VAULT_ADDR="https://vault.voipgrid.nl"
    else
      export VAULT_ADDR="https://vault-dev.voipgrid.nl"
    fi

    secrets="$HOME/Projecten/voipgrid/voipgrid/settings/secrets.txt"

    # The vault token helper holds one token; switching prod<->dev vault needs a
    # re-login. The keyhub OIDC step is near-instant once your browser is authed.
    vault token lookup >/dev/null 2>&1 || vault login -method=oidc -path=keyhub >/dev/null

    # One read == one credential: pull user+pass from the SAME output. Reading
    # twice would mint two users and give you a mismatched pair.
    creds="$(vault read -format=json "database/$database/creds/developer")"
    lease_id="$(jq -r '.lease_id'  <<<"$creds")"
    user="$(jq -r '.data.username' <<<"$creds")"
    pass="$(jq -r '.data.password' <<<"$creds")"

    # Replace the active DEVDB_* lines and our own lease markers; leave your
    # commented "#DEVDB_..." lines and every other comment untouched.
    sed -i -E '/^DEVDB_(USER|PASSWORD)=/d; /^#lease_id=/d; /^#extend:/d' "$secrets"
    {
      printf '#lease_id=%s\n' "$lease_id"
      printf '#extend: VAULT_ADDR=%s vault lease renew -increment=48h %s\n' "$VAULT_ADDR" "$lease_id"
      printf 'DEVDB_USER=%s\n' "$user"
      printf 'DEVDB_PASSWORD=%s\n' "$pass"
    } >>"$secrets"

    echo "vault-login: wrote $target creds for '$user' to secrets.txt (valid ~10h)."
    echo "Now e.g.:  DB=$target docker compose run --rm web ./manage shell_plus"
  '';
}

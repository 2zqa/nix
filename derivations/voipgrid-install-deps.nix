{ pkgs, uv }:

pkgs.writeShellApplication {
  name = "vg-install-deps";

  runtimeInputs = [ uv ];

  text = ''
    dir="''${1:-$HOME/Projecten/voipgrid}"
    cd "$dir"
    cat requirements.txt requirements-dev.txt | grep -vE "^mysqlclient==|^uwsgi==" | uv pip install -r -
  '';
}

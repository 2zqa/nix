{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.vault = {
    enable = mkEnableOption "Vault CLI (unfree)";
  };

  config = mkIf config.vault.enable {
    nixpkgs.config.allowUnfreePackages = [ "vault" ];
    environment.systemPackages = with pkgs; [
      vault
    ];
  };
}

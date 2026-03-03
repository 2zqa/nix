{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.virt-module;
in
{
  options.virt-module = {
    enable = lib.mkEnableOption "virtualization support";
  };

  config = lib.mkIf cfg.enable {
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ "marijnk" ];
    virtualisation.libvirtd.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
  };
}

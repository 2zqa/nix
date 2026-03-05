{
  pkgs,
  config,
  lib,
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
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    users.groups.libvirtd.members = [ "marijnk" ];
    virtualisation.spiceUSBRedirection.enable = true;
    environment.systemPackages = with pkgs; [
      virtiofsd
    ];
  };
}

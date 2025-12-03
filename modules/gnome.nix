{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.gnome-module = {
    enable = mkEnableOption "GNOME Desktop Environment";
  };

  config = mkIf config.gnome-module.enable {
    # Enable the GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      epiphany
      simple-scan
      totem
      yelp
      evince
      file-roller
      geary
      gnome-tour
      gnome-calendar
      gnome-contacts
      gnome-font-viewer
      gnome-logs
      gnome-maps
      gnome-connections
    ];

    nixpkgs.overlays = [
      (final: prev: {
        # Add volume slider
        # https://gitlab.gnome.org/GNOME/gnome-music/-/merge_requests/1058
        gnome-music = prev.gnome-music.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            (prev.fetchpatch {
              url = "https://gitlab.gnome.org/alpeshjamgade/gnome-music/-/commit/dab981a5a20db05f6c3e7abe362181b7ae835736.patch";
              hash = "sha256-UkZ3bMMmjSJAM5lp1okqAwO0Pukx/zfo6m600LoQQlw=";
            })
          ];
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnomeExtensions.unblank
      gnomeExtensions.brightness-control-using-ddcutil
    ];
  };
}

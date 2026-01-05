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
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome.enable = true;

    environment.gnome.excludePackages = with pkgs; [
      epiphany
      simple-scan
      yelp
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
        gnome-music = prev.gnome-music.overrideAttrs (old: {
          patches = (old.patches or [ ]) ++ [
            (prev.fetchpatch {
              url = "https://gitlab.gnome.org/GNOME/gnome-music/-/merge_requests/1096.patch";
              hash = "sha256-fSjIK9mZgcnagD/jvbl4YmG+1meMahQnVHhTrL509KU=";
            })
          ];
        });
      })
    ];

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnome-extension-manager
      gnomeExtensions.unblank
      gnomeExtensions.brightness-control-using-ddcutil
    ];
  };
}

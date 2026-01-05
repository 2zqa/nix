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
    services.displayManager.gdm.enable = true;
    services.desktopManager.gnome = {
      enable = true;
      extraGSettingsOverrides = ''
        [org/gnome/desktop/input-sources]
        xkb-options=['ctrl:nocaps']

        [org/gnome/desktop/peripherals/touchpad]
        disable-while-typing=false

        [org/gnome/desktop/privacy]
        recent-files-max-age=7
        remove-old-temp-files=true
        remove-old-trash-files=true

        # Three minute screen timeout, with 10s grace period
        [org/gnome/desktop/screensaver]
        lock-delay=uint32 10

        [org/gnome/desktop/session]
        idle-delay=uint32 170

        [org/gnome/desktop/wm/keybindings]
        # Remove unused ctrl+alt+shift+up/down keybinds
        move-to-workspace-down=@as []
        move-to-workspace-up=@as []
        # Alt+tab for window switching
        switch-windows=['<Alt>Tab']
        switch-windows-backward=['<Shift><Alt>Tab']
        switch-applications=@as []
        switch-applications-backward=@as []

        [org/gnome/desktop/wm/preferences]
        resize-with-right-button=true

        [org/gnome/mutter]
        dynamic-workspaces=true
        experimental-features=['scale-monitor-framebuffer']
        workspaces-only-on-primary=true

        [org/gnome/settings-daemon/plugins/media-keys]
        play=['<Shift><Control>space']
      '';
    };

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      gnome-extension-manager
      gnomeExtensions.unblank
      gnomeExtensions.brightness-control-using-ddcutil
    ];

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

    # Add volume slider
    nixpkgs.overlays = [
      (final: prev: {
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
  };
}

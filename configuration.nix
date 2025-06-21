# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:

{
  nix = {
    settings = {
      auto-optimise-store = true;
      warn-dirty = false;

      experimental-features = [
        "flakes"
        "nix-command"
      ];
    };

    gc = {
      automatic = true;
      options = "--delete-older-than-5d";
    };

    optimise.automatic = true;
  };
  imports = [
    ./firefox.nix
    ./quietboot.nix
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

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lonepine";

  # Enable networking
  networking.networkmanager.enable = true;

  # networking.firewall = {
  #   enable = true;
  #   allowedTCPPorts = [];
  # };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "nl_NL.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.marijnk = {
    isNormalUser = true;
    description = "Marijn Kok";
    extraGroups = [
      "networkmanager"
      "wheel"
      "docker"
    ];
  };

  # Marijns spul
  programs.bash.promptInit = ''
    # Provide a nice prompt if the terminal supports it.
    if [ "$TERM" != "dumb" ] || [ -n "$INSIDE_EMACS" ]; then
        PROMPT_COLOR="1;31m"
        ((UID)) && PROMPT_COLOR="1;32m"
        if [ -n "$INSIDE_EMACS" ]; then
        # Emacs term mode doesn't support xterm title escape sequence (\e]0;)
        PS1="\[\033[$PROMPT_COLOR\][\u@\h:\w]\\$\[\033[0m\] "
        else
        PS1="\[\033[$PROMPT_COLOR\][\[\e]0;\u@\h: \w\a\]\u@\h:\w]\\$\[\033[0m\] "
        fi
        if test "$TERM" = "xterm"; then
        PS1="\[\033]2;\h:\u:\w\007\]$PS1"
        fi
    fi
  '';
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # Enable fingerprint.
  services.fprintd.enable = true;
  systemd.services.fprintd = {
    wantedBy = [ "multi-user.target" ];
    serviceConfig.Type = "simple";
  };

  # Hardware acceleration
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      #vpl-gpu-rt
      intel-media-driver
    ];
  };
  environment.sessionVariables.LIBVA_DRIVER_NAME = "iHD";

  # Enable dynamic linker to execute dynamic binaries.
  # Needed for Zed to download and execute language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  programs.nix-ld.enable = true;

  programs.git.config.init.defaultBranch = "main";
  virtualisation.docker.enable = true;
  # Flatpak icons are broken: https://github.com/NixOS/nixpkgs/issues/404619
  #services.flatpak.enable = true;
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
    gnome-disk-utility
    gnome-connections
  ];
  services.xserver.excludePackages = [ pkgs.xterm ];

  hardware.i2c.enable = true;
  environment.systemPackages = with pkgs; [
    git
    tree
    wl-clipboard
    neovim
    gnome-tweaks
    chezmoi
    ddcutil

    # apps
    thunderbird
    brave
    blender
    pinta
    papers
    buffer
    shortwave
    identity
    prismlauncher
    signal-desktop
    picard

    # development
    gh
    postgresql
    go
    zulu24
    jetbrains.idea-community
    python313
    zed-editor
    nixd # nix LSP
    nixfmt-rfc-style
    basedpyright
    # vscodium is still needed for:
    #  - Better merge conflict resolvement
    vscodium
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ pkgs, ... }:
let
  jdkWithFX = pkgs.openjdk.override {
    enableJavaFX = true;
  };
in

{
  imports = [
    ./modules/firefox.nix
    ./modules/quietboot.nix
    ./modules/printing.nix
    ./modules/gnome.nix
    ./modules/cosmic.nix
    ./modules/ptyxis-generic-icon.nix
  ];

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
      # options = "--delete-older-than-5d";
    };

    optimise.automatic = true;
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lonepine";

  # Enable networking
  networking.networkmanager.enable = true;
  networking.networkmanager.plugins = with pkgs; [
    networkmanager-openvpn
  ];

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
  gnome-module.enable = true;
  cosmic-module.enable = true;

  # Enable Ozone Wayland support in Chromium and Electron based applications.
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "altgr-intl";
  };

  # Configure console keymap
  console.keyMap = "us-acentos";

  # Enable CUPS to print documents.
  printing-module.enable = true;

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
      "i2c"
    ];
  };

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
  virtualisation.waydroid.enable = true;
  services.flatpak.enable = true;

  # Allow Docker containers to reach host services
  # Accepts traffic from all Docker bridge interfaces (docker0, br-*, etc.)
  networking.firewall = {
    extraCommands = ''
      iptables -I nixos-fw 1 -i br+ -j ACCEPT
      iptables -I nixos-fw 1 -i docker0 -j ACCEPT
    '';
    extraStopCommands = ''
      iptables -D nixos-fw -i br+ -j ACCEPT || true
      iptables -D nixos-fw -i docker0 -j ACCEPT || true
    '';
  };

  services.xserver.excludePackages = [ pkgs.xterm ];

  hardware.i2c.enable = true;
  ptyxis-generic-icon-module.enable = false;
  environment.systemPackages = with pkgs; [
    tree
    android-tools
    wl-clipboard
    neovim
    chezmoi
    ddcutil
    ffmpeg
    yt-dlp

    # fonts
    lora

    # apps
    pixelorama
    inkscape
    popsicle
    libreoffice
    eyedropper
    upscayl
    showtime
    gnome-obfuscate
    gnome-sound-recorder
    clapgrep
    thunderbird
    brave
    pinta
    papers
    buffer
    shortwave
    identity
    prismlauncher
    signal-desktop
    picard
    jmc2obj
    (callPackage ./derivations/simplenote.nix { })
    (callPackage ./derivations/avvie.nix { })
    (callPackage ./derivations/tarug.nix { })
    (callPackage ./derivations/dynamic-wallpaper.nix { })
    (callPackage ./derivations/edex-ui.nix { })

    # development
    git
    delta # beautiful git diffs
    #unstable.flutter338
    unstable.opencode
    gcc
    kubectl
    kubelogin-oidc
    gnupg
    waydroid
    gnumake
    natscli
    unstable.uv
    postgresql
    go
    nodejs_22
    jdkWithFX
    unstable.python314
    unstable.zed-editor
    nixd # nix LSP
    nixfmt
    basedpyright
    unstable.vscodium
    dbgate
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

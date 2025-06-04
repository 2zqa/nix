# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nix.settings.experimental-features = "nix-command flakes";
  imports = [];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lonepine"; # Define your hostname.

  # Enable networking
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      9300 # Google Quick Share
    ];
  };


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
  services.printing.enable = true;

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
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  # Marijns spul
  programs.firefox = {
    enable = true;
    languagePacks = [ "nl" "en-US" ];
    preferences = {
      "mousewheel.min_line_scroll_amount" = 180;
      "mousewheel.default.delta_multiplier_x" = 30;
      "mousewheel.default.delta_multiplier_y" = 30;
    };
  };
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    vimAlias = true;
  };

  # Enable dynamic linker to execute dynamic binaries.
  # Needed for Zed to download and execute language servers.
  # Needed for pre-commit to execute downloaded git hooks.
  programs.nix-ld.enable = true;

  programs.git.config.init.defaultBranch = "main";
  virtualisation.docker.enable = true;
  services.flatpak.enable = true;
  environment.gnome.excludePackages = with pkgs; [
    epiphany
    simple-scan
    totem
    yelp
    evince
    file-roller
    geary
    gnome-tour

    gnome-calendar gnome-contacts
    gnome-font-viewer gnome-logs gnome-maps
    gnome-system-monitor gnome-disk-utility gnome-connections
  ];
  services.xserver.excludePackages = [ pkgs.xterm ];

  environment.systemPackages = with pkgs; [
    git
    tree
    wl-clipboard
    neovim
    gnome-tweaks
    chezmoi

    # Development
    gh
    python313
    zed-editor
    nixd # nix LSP
    basedpyright
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

{
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.sonos-module;
in
{
  options.sonos-module = {
    enable = mkEnableOption "Sonos audio streaming support";
  };

  config = mkIf cfg.enable {
    # Enable Avahi for network device discovery (mDNS/Bonjour)
    # This allows your system to discover Sonos speakers on the network
    services.avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
      publish = {
        enable = true;
        addresses = true;
        userServices = true;
      };
    };

    # Enable PipeWire with PulseAudio compatibility
    services.pipewire = {
      pulse.enable = true;

      # Load RAOP (AirPlay) discovery module to find Sonos speakers
      extraConfig.pipewire-pulse."20-raop-discover" = {
        "pulse.cmd" = [
          {
            cmd = "load-module";
            args = "module-raop-discover";
          }
        ];
      };
    };

    # Open firewall ports for AirPlay/RAOP and mDNS
    networking.firewall = {
      allowedTCPPorts = [
        7000 # AirPlay/RAOP
        5353 # mDNS
      ];
      allowedUDPPorts = [
        5353 # mDNS
        6001 # AirPlay/RAOP
        6002 # AirPlay/RAOP
      ];
    };
  };
}

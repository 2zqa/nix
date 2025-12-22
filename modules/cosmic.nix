{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.cosmic-module = {
    enable = mkEnableOption "COSMIC Desktop Environment";
  };

  config = mkIf config.cosmic-module.enable {
    # Enable the COSMIC Desktop Environment
    # services.displayManager.cosmic-greeter.enable = true;
    services.desktopManager.cosmic.enable = true;

    # Exclude certain COSMIC applications
    environment.cosmic.excludePackages = with pkgs; [
      # Add packages here to exclude from default installation
      # cosmic-edit
    ];

    # Enable system76-scheduler for better performance
    services.system76-scheduler.enable = true;

    # Enable clipboard access for clipboard managers and rapid copy-pasting
    # Warning: This allows all windows to access the clipboard globally
    # environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = 1;

    # Additional system packages for COSMIC
    environment.systemPackages = with pkgs; [
      # Add any additional COSMIC-related packages here
    ];
  };
}

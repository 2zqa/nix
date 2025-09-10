{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.printing-module = {
    enable = mkEnableOption "CUPS printing service with additional drivers";

    drivers = mkOption {
      type = types.listOf types.package;
      default = with pkgs; [
        gutenprint
        hplip
      ];
      description = "List of printer drivers to install";
      example = literalExpression "with pkgs; [ gutenprint hplip ]";
    };
  };

  config = mkIf config.printing-module.enable {
    # Enable CUPS to print documents.
    services.printing = {
      enable = true;
      drivers = config.printing-module.drivers;
    };
  };
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.jdk-fx-module;
in
{
  options.jdk-fx-module = {
    enable = lib.mkEnableOption "JDK with JavaFX support";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [
      (pkgs.openjdk.override {
        enableJavaFX = true;
      })
    ];
  };
}

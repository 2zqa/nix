{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

{
  options.celeste-game = {
    enable = mkEnableOption "Celeste game (unfree)";
  };

  config = mkIf config.celeste-game.enable {
    allowedUnfreePackages = [
      "celeste"
      "celeste-unwrapped"
    ];
    environment.systemPackages = with pkgs; [
      celestegame
    ];
  };
}

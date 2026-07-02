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
    nixpkgs.config.allowUnfreePredicate =
      pkg:
      builtins.elem (lib.getName pkg) [
        "celeste"
        "celeste-unwrapped"
      ];
    environment.systemPackages = with pkgs; [
      celestegame
    ];
  };
}

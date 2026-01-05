{
  config,
  lib,
  ...
}:

with lib;

{
  options.ptyxis-generic-icon-module = {
    enable = mkEnableOption "Use Ptyxis generic icon";
  };

  config = mkIf config.ptyxis-generic-icon-module.enable {
    nixpkgs.overlays = [
      (final: prev: {
        ptyxis = prev.ptyxis.overrideAttrs (old: {
          mesonFlags = (old.mesonFlags or [ ]) ++ [
            "-Dgeneric=terminal"
          ];
        });
      })
    ];
  };
}

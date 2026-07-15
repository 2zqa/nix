{
  config,
  lib,
  ...
}:

with lib;

{
  options.allowedUnfreePackages = mkOption {
    type = types.listOf types.str;
    default = [ ];
    description = "List of unfree package names to allow.";
  };

  config = mkIf (config.allowedUnfreePackages != [ ]) {
    nixpkgs.config.allowUnfreePredicate =
      pkg: builtins.elem (lib.getName pkg) config.allowedUnfreePackages;
  };
}

{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs =
    { nixpkgs, nixpkgs-unstable, ... }:
    {
      nixosConfigurations = {
        # This should correspond to the hostname of the machine
        lonepine = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [
            ./configuration.nix
            ./hardware-configuration.nix
            {
              nixpkgs.overlays = [
                (final: prev: {
                  unstable = nixpkgs-unstable.legacyPackages.${prev.system};
                })
              ];
            }
          ];
        };
      };
    };
}

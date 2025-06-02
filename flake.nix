{
  description = "NixOS System Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/25.05";
  };

  outputs = { self, nixpkgs }: {
    nixosConfigurations = {
      # This should correspond to the hostname of the machine
      lonepine = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };
    };
  };
}

# Installation

1. `nix-shell -p git --run "git clone https://github.com/2zqa/nix.git && cd nix`
2. `rm ./hardware-configuration.nix && sudo cp /etc/nixos/hardware-configuration.nix . && sudo chown $USER:users ./hardware-configuration.nix`
3. `sudo nixos-rebuild switch --flake ~/nix#lonepine`
4. Reboot the system, ensuring everything works
5. `sudo nix-channel --remove nixos` (Maybe not needed?)

## Acknowledgments

- Philipp Schuster for writing [Migrate Default NixOS Configuration to Flake](https://phip1611.de/blog/migrate-stock-nixos-configuration-to-flake/)

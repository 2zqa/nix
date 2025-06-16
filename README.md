# Installation

1. `nix-shell -p git --run "git clone https://github.com/2zqa/nix.git && cd nix && rm ./hardware-configuration.nix && sudo cp /etc/nixos/hardware-configuration.nix . && sudo chown $USER:users ./hardware-configuration.nix`
2. `sudo nixos-rebuild switch --flake .#lonepine`
3. Reboot the system, ensuring everything works
5. `sudo nix-channel --remove nixos` (Maybe not needed?)

https://phip1611.de/blog/migrate-stock-nixos-configuration-to-flake/

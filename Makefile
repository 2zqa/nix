.PHONY: default
default:
	sudo nixos-rebuild --flake ~/nix#lonepine switch

.PHONY: default
default:
	sudo nixos-rebuild --flake ~/nix#lonepine switch
update:
	nix flake update
	sudo nixos-rebuild --flake ~/nix#lonepine switch

.PHONY: default
default:
	sudo nixos-rebuild --flake ~/nix#lonepine switch

update:
	sudo -v
	nix flake update
	sudo nixos-rebuild --flake ~/nix#lonepine switch

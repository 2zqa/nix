.PHONY: default
default:
	sudo nixos-rebuild --flake ~/nix#lonepine switch

update:
	sudo -v
	nix flake update
	sudo nixos-rebuild --flake ~/nix#lonepine switch

upgrade: update

dry-build:
	sudo nixos-rebuild dry-build --flake ~/nix#lonepine

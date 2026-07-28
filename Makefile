.PHONY: default
default:
	sudo nixos-rebuild --flake ~/nix#lonepine switch

update:
	sudo -v
	nix flake update
	sudo nixos-rebuild --flake ~/nix#lonepine switch

upgrade: update

celeste:
	nix-store --add-fixed sha256 ~/Documenten/celeste-linux.zip

dry-build:
	sudo nixos-rebuild dry-build --flake ~/nix#lonepine

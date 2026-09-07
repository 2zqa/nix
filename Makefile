.PHONY: default
default:
	@git add derivations/ modules/
	sudo nixos-rebuild --flake ~/nix#lonepine switch

update: sudo celeste
	nix flake update
	sudo nixos-rebuild --flake ~/nix#lonepine switch

upgrade: update

sudo:
	sudo -v

gc: sudo
	sudo nix-collect-garbage --delete-older-than 1d

celeste:
	nix-store --add-fixed sha256 ~/Documenten/celeste-linux.zip

dry-build:
	sudo nixos-rebuild dry-build --flake ~/nix#lonepine

.PHONY: build
build:
	darwin-rebuild switch --flake '.#ohyeong-geun' --show-trace

.PHONY: fmt
fmt:
	nix fmt . --extra-experimental-features 'nix-command flakes'

.PHONY: init
init:
	nix run nix-darwin --extra-experimental-features flakes --extra-experimental-features nix-command -- switch --flake .#ohyeong-geun

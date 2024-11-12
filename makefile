.PHONY: build
build:
	darwin-rebuild switch --flake '.#user' --show-trace

.PHONY: fmt
fmt:
	nix fmt . --extra-experimental-features 'nix-command flakes'

.PHONY: build
build:
	darwin-rebuild switch --flake '.#ohyeong-geun' --show-trace

.PHONY: fmt
fmt:
	nix fmt . --extra-experimental-features 'nix-command flakes'

.PHONY: init
init:
	nix run nix-darwin --extra-experimental-features flakes --extra-experimental-features nix-command -- switch --flake .#ohyeong-geun

.PHONY: build-linux
build-linux:
	home-manager switch --flake '.#ec2-user' -b hm-backup --show-trace

.PHONY: init-linux
init-linux:
	nix build '.#homeConfigurations.ec2-user.activationPackage' --extra-experimental-features 'nix-command flakes'
	HOME_MANAGER_BACKUP_EXT=hm-backup ./result/activate

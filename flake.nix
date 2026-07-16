{
  description = "Geun Oh Defualt Nix Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixos-hardware.url = "github:nixos/nixos-hardware";
    flake-utils.url = "github:numtide/flake-utils?rev=13faa43c34c0c943585532dacbb457007416d50b";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    terraform = {
      url = "github:stackbuilders/nixpkgs-terraform";
    };

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixos-hardware,
      darwin,
      home-manager,
      terraform,
      ...
    }:
    let
      username = "ohyeong-geun";
      system = "aarch64-darwin";

      linuxUsername = "ec2-user";
      linuxSystem = "x86_64-linux";

      specialArgs = {
        inherit inputs username;
      };

    in
    {
      darwinConfigurations = {
        "ohyeong-geun" = darwin.lib.darwinSystem {
          inherit system specialArgs;
          modules = [
            home-manager.darwinModules.home-manager
            ./darwin.nix
          ];
        };
      };

      # Standalone home-manager for Linux hosts:
      #   home-manager switch --flake '.#ec2-user'
      homeConfigurations = {
        "${linuxUsername}" = home-manager.lib.homeManagerConfiguration {
          pkgs = import nixpkgs {
            system = linuxSystem;
            config.allowUnfree = true;
          };
          extraSpecialArgs = {
            inherit inputs;
            username = linuxUsername;
          };
          modules = [ ./modules/linux/home.nix ];
        };
      };

      formatter = {
        ${system} = nixpkgs.legacyPackages.${system}.nixfmt;
        ${linuxSystem} = nixpkgs.legacyPackages.${linuxSystem}.nixfmt;
      };
      devShells.${system}.default = nixpkgs.legacyPackages.${system}.mkShell {
        buildInputs = [ terraform.packages.${system}."1.10.1" ];
      };
    };
}

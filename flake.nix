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
  };

  nix-vscode-extensions = {
    url = "github:nix-community/nix-vscode-extensions";
    inputs.nixpkgs.follows = "nixpkgs";
    inputs.flake-utils.follows = "flake-utils";
    inputs.flake-compat.follows = "flake-compat";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixos-hardware,
      darwin,
      home-manager,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
    };
}

{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    zsh
    biome
  ];

  environment.systemPath = [
    "$HOME/go/bin"
    "$HOME/.cargo/bin"
    "$HOME/.npm-global/bin"
  ];

  nix = {
    package = pkgs.nix;
    settings = {
      "extra-experimental-features" = [
        "nix-command"
        "flakes"
      ];
    };
  };

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystem = true;
    };
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}

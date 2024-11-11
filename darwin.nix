{
  config,
  pkgs,
  inputs,
  ...
}:

{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  # environment.darwinConfig = "$HOME/src/github.com/evantravers/dotfiles/nix-darwin-configuration";

  environment.systemPackages = with pkgs; [
    zsh
  ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
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

  users.users.user = {
    shell = pkgs.bashInteractive;
    home = "/Users/user";
  };

  home-manager = {
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "user" = import ./home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;

  homebrew = {
    enable = true;

    casks = [
      "obsidian"
      # "raycast"
      "cursor"
    ];

    masApps = {
      "KakaoTalk" = 869223134;
    };
  };

  system.defaults = {
    dock = {
      autohide = true;
      orientation = "left";
      show-process-indicators = false;
      show-recents = false;
      static-only = true;
    };
    finder = {
      AppleShowAllExtensions = true;
      ShowPathbar = true;
      FXEnableExtensionChangeWarning = false;
    };
    NSGlobalDomain = {
      AppleKeyboardUIMode = 3;
      ApplePressAndHoldEnabled = false;
      "com.apple.keyboard.fnState" = true;
    };
  };
}

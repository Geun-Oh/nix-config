{
  config,
  pkgs,
  inputs,
  ...
}:

{
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.user =
    { config, ... }:
    {
      home.username = "user";
      home.homeDirectory = "/Users/user";

      home.packages = with pkgs; [
        curl
        code-cursor
      ];
      imports = [
        ../shared/programs/act
        ../shared/programs/aws
        ../shared/programs/bat
        ../shared/programs/container
        # ../shared/programs/direnv
        # ../shared/programs/fonts
        ../shared/programs/git
        ../shared/programs/go
        ../shared/programs/gpg
        ../shared/programs/jq
        ../shared/programs/kubernetes
        # ../shared/programs/lsd
        ../shared/programs/nix
        ../shared/programs/node
        # ../shared/programs/python
        ../shared/programs/rust
        ../shared/programs/shell
        ../shared/programs/ssh
        ../shared/programs/terraform
        ../shared/programs/tmux
        # ../shared/programs/vercel
        # ../shared/programs/vscode
        # ../shared/programs/wezterm
        ../shared/programs/xdg
      ];

      home.stateVersion = "22.05";
    };
}

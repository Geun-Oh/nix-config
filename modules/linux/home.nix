{
  config,
  pkgs,
  username,
  ...
}:

{
  imports = [
    ../shared/programs/git
    ../shared/programs/gpg
    ../shared/programs/jq
    ../shared/programs/kubernetes
    ../shared/programs/nix
    ../shared/programs/terraform
    ../shared/programs/xdg
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    kubectl
    istioctl
    kubernetes-helm
    terraform
    tmux
    curl
    tree
  ];

  programs.home-manager.enable = true;

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
    defaultCacheTtl = 3600;
    maxCacheTtl = 86400;
  };

  programs.bash = {
    enable = true;

    shellAliases = {
      gs = "git status -sb";
      k = "kubectl";
      tf = "terraform";
    };

    initExtra = ''
      # Source global definitions
      if [ -f /etc/bashrc ]; then
        . /etc/bashrc
      fi

      # Nix (daemon) profile, for non-login shells
      if [ -f /etc/profile.d/nix.sh ]; then
        . /etc/profile.d/nix.sh
      fi

      # Basic PATH settings
      case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) export PATH="$HOME/.local/bin:$HOME/bin:$HOME/go/bin:$HOME/.cargo/bin:$HOME/.npm-global/bin:$PATH" ;;
      esac

      # Home Manager session variables
      if [ -f "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh" ]; then
        . "$HOME/.nix-profile/etc/profile.d/hm-session-vars.sh"
      fi

      # GPG commit signing over SSH sessions
      export GPG_TTY=$(tty)

      # Machine-local settings (not managed by Nix)
      if [ -d "$HOME/.bashrc.d" ]; then
        for rc in "$HOME"/.bashrc.d/*; do
          if [ -f "$rc" ]; then
            . "$rc"
          fi
        done
        unset rc
      fi
    '';
  };
}

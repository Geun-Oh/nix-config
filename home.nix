{
  config,
  pkgs,
  libs,
  inputs,
  ...
}:
{
  home.stateVersion = "24.05"; # Please read the comment before changing.
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    vscode
    bat
    hugo
    act
    tree
    warp-terminal
    go
    terraform
  ];

  home.sessionVariables = {
    GOPATH = "${config.home.homeDirectory}/go";
  };

  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      syntaxHighlighting.highlighters = [
        "main"
      ];
      oh-my-zsh = {
        enable = true;
        theme = "robbyrussell";
        plugins = [
          "git"
          "npm"
          "history"
          "node"
          "rust"
          "deno"
        ];
      };

    };

    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        equinusocio.vsc-material-theme
        equinusocio.vsc-material-theme-icons
        vscodevim.vim
        yzhang.markdown-all-in-one
        bierner.markdown-preview-github-styles
        charliermarsh.ruff
        davidanson.vscode-markdownlint
        eamodio.gitlens
        editorconfig.editorconfig
        esbenp.prettier-vscode
        foxundermoon.shell-format
        golang.go
        hashicorp.terraform
        jnoortheen.nix-ide
        ms-kubernetes-tools.vscode-kubernetes-tools
        prisma.prisma
        redhat.java
        redhat.vscode-yaml
        rust-lang.rust-analyzer
        shardulm94.trailing-spaces
        tamasfe.even-better-toml
        usernamehw.errorlens
        yoavbls.pretty-ts-errors
        ms-vscode.makefile-tools
      ];
    };
  };
}

{
  config,
  pkgs,
  inputs,
  ...
}:
{
  imports = [
    # ../shared/programs/act
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
    # ../shared/programs/node
    # ../shared/programs/python
    ../shared/programs/rust
    # ../shared/programs/shell
    ../shared/programs/ssh
    ../shared/programs/terraform
    ../shared/programs/tmux
    # ../shared/programs/vim
    # ../shared/programs/vercel
    # ../shared/programs/vscode
    # ../shared/programs/wezterm
    ../shared/programs/xdg
  ];
  home.stateVersion = "24.11";

  home.sessionVariables = {
          GOPATH = "${config.home.homeDirectory}/go";
        };

  home.packages = with pkgs; [
    curl
    bat
    act
    tree
    warp-terminal
    nodejs_23
    pnpm_8
    terraform
    typescript
    neovim
    sbt
    scala
    codebuff
    nest-cli
    uv
  ];

  programs = {
    zsh = {
      enable = true;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      syntaxHighlighting.highlighters = [
        "main"
      ];
      initExtra = ''
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';
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
      profiles.default.extensions = with pkgs.vscode-extensions; [
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
        mhutchie.git-graph
        adpyke.codesnap
        gruntfuggly.todo-tree
        biomejs.biome
        ziglang.vscode-zig
      ];
    };
  };
}

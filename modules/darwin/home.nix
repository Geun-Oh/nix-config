{
  config,
  pkgs,
  inputs,
  ...
}:
let
  piManagedPackages = [
    "npm:oh-pi@0.1.85"
    "npm:pi-interactive-shell@0.9.0"
    "npm:pi-librarian@1.3.0"
    "npm:pi-markdown-preview@0.9.1"
    "npm:pi-screenshots-picker@1.2.1"
    "npm:pi-subagents@0.11.0"
    "npm:pi-web-access@0.10.2"
    "npm:pi-google-workspace@1.0.1"
  ];
in
{
  imports = [
    # ../shared/programs/act
    ../shared/programs/agents
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
    nodejs_24
    pnpm_8
    terraform
    typescript
    neovim
    sbt
    scala
    # Legacy AI CLI (disabled): codebuff
    # codebuff
    nest-cli
    uv
    # Legacy AI wrapper (disabled): antigravity
    # (writeShellScriptBin "antigravity" ''
    #   exec "/Applications/Antigravity.app/Contents/Resources/app/bin/antigravity" "$@"
    # '')
    ghostty-bin
  ];

  # Pi global settings (declarative)
  # NOTE: We intentionally do NOT manage ~/.pi/agent/extensions via Nix,
  # so manually added global extensions keep working.
  home.file.".pi/agent/settings.json".text = builtins.toJSON {
    theme = "dark";
    quietStartup = true;
    transport = "auto";
    defaultThinkingLevel = "medium";

    # Pi packages are declaratively managed via Nix/Home Manager.
    # pi reads this list and auto-installs missing packages on startup.
    packages = piManagedPackages;

    # Keep empty to avoid duplicated loading from ad-hoc local paths.
    extensions = [ ];

    compaction = {
      enabled = true;
      reserveTokens = 16384;
      keepRecentTokens = 20000;
    };

    retry = {
      enabled = true;
      maxRetries = 3;
      baseDelayMs = 2000;
      maxDelayMs = 60000;
    };

    enableSkillCommands = true;
    skills = [
      "/opt/homebrew/lib/node_modules/oh-pi/pi-package/skills"
      "~/.agents/skills"
    ];
  };

  programs.agents = {
    enable = true;

    promptFiles = {
      default-agent = {
        source = ../shared/programs/agents/files/prompts/default-agent.md;
        target = ".config/agents/prompts/default-agent.md";
        templateVars = {
          repo_name = "nix-config";
          user_name = "ohyeong-geun";
        };
      };

      repo-agents = {
        source = ../shared/programs/agents/files/prompts/repo-AGENTS.md;
        target = ".config/agents/prompts/repo-AGENTS.md";
      };
    };

    # Legacy AI tool config (Codex/OMX) is intentionally minimized.
    # Keep disabled by default while using pi as primary tool.
    # codex = {
    #   enable = true;
    #   ...
    # };
    codex.enable = false;
    omx.enable = false;
    tmux.enable = false;
  };

  programs = {
    zsh = {
      enable = true;
      dotDir = config.home.homeDirectory;
      autosuggestion.enable = true;
      syntaxHighlighting.enable = true;
      syntaxHighlighting.highlighters = [
        "main"
      ];

      shellAliases = {
        gs = "git status -sb";
        k = "kubectl";
        tf = "terraform";
        gl = "git log --graph --decorate --oneline --all --color --pretty=format:'%C(auto)%h %C(cyan)%ad%C(reset) %C(bold yellow)%d%C(reset) %s %C(dim
  white)- %an%C(reset)' --date=short";
      };

      initContent = ''
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

    ghostty = {
      enable = true;
      package = pkgs.ghostty-bin;
      settings = {
        theme = "Niji";
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
        adpyke.codesnap
        gruntfuggly.todo-tree
        biomejs.biome
        ziglang.vscode-zig
      ];
    };
  };
}

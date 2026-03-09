{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.agents;
  types = lib.types;
  jsonFormat = pkgs.formats.json { };
  tomlFormat = pkgs.formats.toml { };
  codexReservedSettingsKeys = [
    "projects"
    "mcp_servers"
    "features"
    "tui"
  ];

  renderTemplate =
    vars: content:
    lib.foldl' (acc: key: lib.replaceStrings [ "{{${key}}}" ] [ vars.${key} ] acc) content (
      builtins.attrNames vars
    );

  mkPromptFileSpec =
    promptCfg:
    let
      useTemplate = builtins.length (builtins.attrNames promptCfg.templateVars) > 0;
      renderedText =
        if useTemplate then
          renderTemplate promptCfg.templateVars (builtins.readFile promptCfg.source)
        else
          null;
    in
    if useTemplate then
      {
        text = renderedText;
        executable = promptCfg.executable;
      }
    else
      {
        source = promptCfg.source;
        executable = promptCfg.executable;
      };

  promptConfigFiles = lib.mapAttrs' (
    _: promptCfg:
    lib.nameValuePair (lib.removePrefix ".config/" promptCfg.target) (mkPromptFileSpec promptCfg)
  ) (lib.filterAttrs (_: promptCfg: lib.hasPrefix ".config/" promptCfg.target) cfg.promptFiles);

  promptHomeFiles = lib.mapAttrs' (
    _: promptCfg: lib.nameValuePair promptCfg.target (mkPromptFileSpec promptCfg)
  ) (lib.filterAttrs (_: promptCfg: !lib.hasPrefix ".config/" promptCfg.target) cfg.promptFiles);

  normalizedRuntimeTargets = map (target: lib.removeSuffix "/" target) cfg.runtime.excludeTargets;
  isBlockedTarget =
    target:
    lib.any (blocked: target == blocked || lib.hasPrefix "${blocked}/" target) normalizedRuntimeTargets;

  promptAssertions = lib.mapAttrsToList (name: promptCfg: {
    assertion = !lib.hasPrefix "/" promptCfg.target && !isBlockedTarget promptCfg.target;
    message = "programs.agents.promptFiles.${name}.target must be relative and cannot write into blocked runtime paths.";
  }) cfg.promptFiles;

  codexSettingsAssertions = map (key: {
    assertion = !lib.hasAttrByPath [ key ] cfg.codex.settings;
    message = "programs.agents.codex.settings cannot contain `${key}`. Use programs.agents.codex.${
      if key == "mcp_servers" then "mcpServers" else key
    }.";
  }) codexReservedSettingsKeys;

  codexConfig =
    cfg.codex.settings
    // lib.optionalAttrs (cfg.codex.projects != { }) {
      projects = cfg.codex.projects;
    }
    // lib.optionalAttrs (cfg.codex.mcpServers != { }) {
      mcp_servers = cfg.codex.mcpServers;
    }
    // lib.optionalAttrs (cfg.codex.features != { }) {
      features = cfg.codex.features;
    }
    // lib.optionalAttrs (cfg.codex.tui != { }) {
      tui = cfg.codex.tui;
    };

  # opencodeConfig = cfg.opencode.extraSettings // {
  #   "$schema" = cfg.opencode.schemaUrl;
  #   plugin = cfg.opencode.plugins;
  # };

  # ohMyOpencodeConfig = cfg.opencode.ohMy.extraSettings // {
  #   "$schema" = cfg.opencode.ohMy.schemaUrl;
  #   agents = cfg.opencode.ohMy.agents;
  #   categories = cfg.opencode.ohMy.categories;
  # };
in
{
  options.programs.agents = {
    enable = lib.mkEnableOption "agent prompt and tool configuration";

    promptFiles = lib.mkOption {
      type = types.attrsOf (
        types.submodule (
          { name, ... }:
          {
            options = {
              source = lib.mkOption {
                type = types.path;
                description = "Source markdown/text file path.";
              };

              target = lib.mkOption {
                type = types.str;
                default = ".config/agents/prompts/${name}.md";
                description = "Relative path in HOME. Paths starting with .config/ use xdg.configFile.";
              };

              executable = lib.mkOption {
                type = types.bool;
                default = false;
                description = "Mark rendered file as executable.";
              };

              templateVars = lib.mkOption {
                type = types.attrsOf types.str;
                default = { };
                description = "Template values rendered as {{key}} placeholders.";
              };
            };
          }
        )
      );
      default = { };
      description = "Prompt files managed declaratively by Home Manager.";
    };

    codex = {
      enable = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Manage Codex CLI configuration.";
      };

      settings = lib.mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Top-level Codex TOML keys except projects/mcp_servers/features/tui.";
      };

      projects = lib.mkOption {
        type = types.attrsOf (types.attrsOf types.anything);
        default = { };
        description = "Entries written into [projects.\"<path>\"]";
      };

      mcpServers = lib.mkOption {
        type = types.attrsOf (types.attrsOf types.anything);
        default = { };
        description = "Entries written into [mcp_servers.<name>].";
      };

      features = lib.mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Entries written into [features].";
      };

      tui = lib.mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Entries written into [tui].";
      };
    };

    # opencode = {
    #   enable = lib.mkOption {
    #     type = types.bool;
    #     default = true;
    #     description = "Manage OpenCode configuration files.";
    #   };
    #
    #   schemaUrl = lib.mkOption {
    #     type = types.str;
    #     default = "https://opencode.ai/config.json";
    #     description = "Schema URL written into opencode.json.";
    #   };
    #
    #   plugins = lib.mkOption {
    #     type = types.listOf types.str;
    #     default = [ ];
    #     description = "OpenCode plugins written into opencode.json plugin list.";
    #   };
    #
    #   extraSettings = lib.mkOption {
    #     type = types.attrsOf types.anything;
    #     default = { };
    #     description = "Additional OpenCode settings merged into opencode.json.";
    #   };
    #
    #   ohMy = {
    #     enable = lib.mkOption {
    #       type = types.bool;
    #       default = true;
    #       description = "Manage oh-my-opencode.json.";
    #     };
    #
    #     schemaUrl = lib.mkOption {
    #       type = types.str;
    #       default = "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json";
    #       description = "Schema URL written into oh-my-opencode.json.";
    #     };
    #
    #     agents = lib.mkOption {
    #       type = types.attrsOf (types.attrsOf types.anything);
    #       default = { };
    #       description = "oh-my-opencode agents map.";
    #     };
    #
    #     categories = lib.mkOption {
    #       type = types.attrsOf (types.attrsOf types.anything);
    #       default = { };
    #       description = "oh-my-opencode categories map.";
    #     };
    #
    #     extraSettings = lib.mkOption {
    #       type = types.attrsOf types.anything;
    #       default = { };
    #       description = "Additional oh-my-opencode settings merged into oh-my-opencode.json.";
    #     };
    #   };
    # };

    omx = {
      enable = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Manage OMX config files.";
      };

      hudPreset = lib.mkOption {
        type = types.str;
        default = "focused";
        description = "Value written to .omx/hud-config.json preset.";
      };

      settings = lib.mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "Additional OMX settings written to .omx/config.json.";
      };
    };

    antigravity = {
      enable = lib.mkOption {
        type = types.bool;
        default = false;
        description = "Manage .antigravity/argv.json.";
      };

      argv = lib.mkOption {
        type = types.attrsOf types.anything;
        default = { };
        description = "argv.json payload for Antigravity (VS Code fork).";
      };
    };

    runtime = {
      excludeTargets = lib.mkOption {
        type = types.listOf types.str;
        default = [
          ".omx/state"
          ".omx/logs"
          ".omx/plans"
          ".codex/auth.json"
          # ".config/opencode/antigravity-accounts.json"
        ];
        description = "Runtime/auth targets that must remain unmanaged.";
      };
    };

    tmux = {
      enable = lib.mkOption {
        type = types.bool;
        default = true;
        description = "Append agent integration config to tmux.";
      };

      extraConfig = lib.mkOption {
        type = types.lines;
        default = ''
          # Agent integration (managed by programs.agents)
          set -g @omx-enabled "1"
        '';
        description = "Extra tmux config appended after existing settings.";
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        assertions = promptAssertions ++ codexSettingsAssertions;

        home.file = lib.mkMerge [
          (lib.mkIf cfg.codex.enable {
            ".codex/config.toml".source = tomlFormat.generate "codex-config.toml" codexConfig;
          })
          (lib.mkIf cfg.omx.enable {
            ".omx/hud-config.json".source = jsonFormat.generate "omx-hud-config.json" {
              preset = cfg.omx.hudPreset;
            };
          })
          (lib.mkIf (cfg.omx.enable && cfg.omx.settings != { }) {
            ".omx/config.json".source = jsonFormat.generate "omx-config.json" cfg.omx.settings;
          })
          (lib.mkIf cfg.antigravity.enable {
            ".antigravity/argv.json".source = jsonFormat.generate "antigravity-argv.json" cfg.antigravity.argv;
          })
          promptHomeFiles
        ];

        xdg.configFile = lib.mkMerge [
          # (lib.mkIf cfg.opencode.enable {
          #   "opencode/opencode.json".source = jsonFormat.generate "opencode.json" opencodeConfig;
          # })
          # (lib.mkIf (cfg.opencode.enable && cfg.opencode.ohMy.enable) {
          #   "opencode/oh-my-opencode.json".source =
          #     jsonFormat.generate "oh-my-opencode.json" ohMyOpencodeConfig;
          # })
          promptConfigFiles
        ];

        programs.tmux.extraConfig = lib.mkIf cfg.tmux.enable (lib.mkAfter cfg.tmux.extraConfig);
      }
    ]
  );
}

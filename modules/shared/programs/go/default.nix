{
  config,
  lib,
  pkgs,
  ...
}:

{
  # imports = [ TODO
  #   ./gvm.nix
  # ];

  home.sessionVariables = {
    GOPATH = "${config.xdg.configHome}/go";
  };

  programs.go.enable = true;
}

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
    GOPATH = "${config.home.homeDirectory}/go";
  };

  programs.go.enable = true;
}

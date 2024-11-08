{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./gvm.nix
  ];

  home.sessionVariables = {
    GOPATH = "${config.xdg.configHome}/go";
  };

  home.packages = with pkgs; [
    go
  ];
}

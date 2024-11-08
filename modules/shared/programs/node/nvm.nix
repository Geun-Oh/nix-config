{ config, pkgs, ... }:

{

  programs.nvm.enable = true;

  programs.nvm.nodeVersions = [
    "20.18.0"
    "22.11.0"
  ];

  programs.nvm.defaultNodeVersion = "22.11.0";
}

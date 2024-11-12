{ config, pkgs, ... }:

{
  xdg = {
    enable = true;
  };
  
  xdg.configHome = "${config.home.homeDirectory}/.config";
}

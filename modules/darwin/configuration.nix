{ config, pkgs, ... }:

{
  nix.useDaemon = true;

  security.pam = {
    enableSudoTouchIdAuth = true;
  };

  programs.bash = {
    enable = true;
  };

  users.users.user = {
    shell = pkgs.bashInteractive;
    home = "/Users/user";
  };

  environment = {
    shells = [ pkgs.bashInteractive ];
    pathsToLink = [ "/share/qemu" ];
  };

  # should set default mac settings
}
{ config, pkgs, ... }:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks."*" = { };
    extraConfig = ''
      AddressFamily inet
      StrictHostKeyChecking no
    '';
  };
}

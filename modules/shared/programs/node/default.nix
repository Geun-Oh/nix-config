{
  config,
  lib,
  pkgs,
  ...
}:

{
  imports = [
    ./nvm.nix
  ];

  home.packages = with pkgs; [
    nodejs_20
    pnpm
  ];
}

{ config, pkgs, ... }:

{
  home.sessionVariables = {
    CARGO_HOME = "${config.xdg.configHome}/cargo";
    RUSTUP_HOME = "${config.xdg.configHome}/rustup";
  };

  home.packages = with pkgs; [
    rustc
    rustup
  ];

  programs.bash.initExtra = ''
    rustup default stable
  '';
}

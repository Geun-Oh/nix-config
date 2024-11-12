{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Geun-Oh";
    userEmail = "kandy1002@naver.com";
    signing = {
      key = "0xAA91CDD655CCD6E6";
      signByDefault = true;
    };
    ignores = [
      ".DS_Store"
      ".direnv"
      ".envrc"
      ".spr.yml"
      "*.pem"
    ];
    extraConfig = {
      credential.helper = "";
      credential."https://github.com".helper = "!gh auth git-credential";
      init.defaultBranch = "main";
      core.editor = "vim";
    };
  };
}

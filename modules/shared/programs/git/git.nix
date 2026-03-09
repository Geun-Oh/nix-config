{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
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
    settings = {
      user.name = "Geun-Oh";
      user.email = "kandy1002@naver.com";
      credential.helper = "";
      credential."https://github.com".helper = "!gh auth git-credential";
      init.defaultBranch = "main";
      core.editor = "vim";
    };
  };
}

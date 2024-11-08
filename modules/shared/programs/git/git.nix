{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "Geun-Oh";
    userEmail = "kandy1002@naver.com";
    signing = {
      key = "47A7AEC719D6933917E8C71676921B0EB1B067B4";
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
      diff.age-differ = {
        textconv = "${pkgs.rage}/bin/rage -d -i ${builtins.elemAt config.secrets.identityPaths 0}";
      };
      init.defaultBranch = "main";
    };
  };
}

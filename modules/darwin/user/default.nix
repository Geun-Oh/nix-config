{ pkgs, ... }:

{
  users.users.ohyeong-geun = {
    shell = pkgs.bashInteractive;
    home = "/Users/ohyeong-geun";
  };
}

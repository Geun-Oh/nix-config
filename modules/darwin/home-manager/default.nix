{ inputs, pkgs, ... }:

{
  home-manager = {
    backupFileExtension = null;
    backupCommand = pkgs.writeShellScript "home-manager-backup-command" ''
      set -eu

      target="$1"
      ts="$(date +%Y%m%d-%H%M%S)"
      backup="''${target}.hm-backup.''${ts}"
      idx=0

      while [ -e "$backup" ]; do
        idx=$((idx + 1))
        backup="''${target}.hm-backup.''${ts}.''${idx}"
      done

      mv "$target" "$backup"
    '';
    extraSpecialArgs = {
      inherit inputs;
    };
    users = {
      "ohyeong-geun" = import ../home.nix;
    };
    useGlobalPkgs = true;
    useUserPackages = true;
  };
}

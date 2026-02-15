{ inputs, ... }:

{
  home-manager = {
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

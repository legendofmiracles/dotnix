{
  description = "system config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
  };

  outputs = { self, nixpkgs, home-manager, utils }@inputs:
    utils.lib.systemFlake {
      inherit self inputs;
      channels.nixpkgs = {
         input = nixpkgs;
         config = {
           allowUnfree = true;
        };
      };

      nixosProfiles = {
        pain = {
          modules = [
            ./configuration.nix
          ];
        };
      };
    };
}

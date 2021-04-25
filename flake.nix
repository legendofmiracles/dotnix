{
  description = "system config";

  inputs = {
    # nixpkgs.url = "github:nixos/nixpkgs/6869845ff1d1252a9b727509213c81b27e10f48c";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
  };

  outputs = { self, nixpkgs, home-manager, utils, nur }@inputs:
    utils.lib.systemFlake {
      inherit self inputs;

      channels.nixpkgs = {
         input = nixpkgs;
         config = {
           allowUnfree = true;
        };
      };

      hosts = {
        pain = {
          modules = [
            ./configuration.nix
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              # home-manager.users.nix = import ./HM/home.nix;
            }
             ({ pkgs, ... }: {
              home-manager.users.nix = import ./HM/home.nix;
            })
          ];
        };
      };

      sharedOverlays = [
        nur.overlay
      ];
    };
}

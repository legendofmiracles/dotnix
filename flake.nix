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
    # rust-nix-templater.url = "github:yusdacra/rust-nix-templater";
  };

  outputs = { self, nixpkgs, home-manager, utils, nur, rust-nix-templater }@inputs:
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
            # rust-nix-templater.nixosModules.rust-nix-templater
            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
            }
             ({ pkgs, ... }: {
              home-manager.users.nix = import ./HM/home.nix;
              environment.shellAliases = {
                nix-repl = "nix repl ${inputs.utils.lib.repl}";
              };
            })
          ];
        };
      };

      sharedOverlays = [
        nur.overlay
      ];

      hostDefaults.modules = [ utils.nixosModules.saneFlakeDefaults ];
    };
}

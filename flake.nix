{
  description = "LegendOfMiracles's system config";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
#    nixpkgs-cloned.url = "file:/home/nix/nixpkgs/";
    home-manager.url = "github:nix-community/home-manager";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
  };

  outputs = { self, nixpkgs, home-manager, utils, nur, nixos-hardware }@inputs:
    utils.lib.systemFlake {
      inherit self inputs;

       nixosModules = utils.lib.modulesFromList [
         ./udev.nix
         ./secrets/wifi.nix
         ./xorg.nix
         # ./HM/proton.nix
         ./v4l2.nix
       ];

      channels.nixpkgs = {
         input = nixpkgs;
         config = {
           allowUnfree = true;
        };
      };

      hosts = {
        pain = {
          modules = with self.nixosModules; [
            ./configuration.nix
            xorg
            v4l2
            udev
            nixos-hardware.nixosModules.common-cpu-intel
            wifi
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

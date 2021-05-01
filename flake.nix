{
  description = "LegendOfMiracles's system config";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-cloned.url = "file:/home/nix/nixpkgs/";
    home-manager.url = "github:nix-community/home-manager";
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus/staging";
  };

  outputs = { self, nixpkgs, home-manager, utils, nur, nixos-hardware, nixpkgs-unstable }@inputs:
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

      channels.nixpkgs-unstable = {
        input = nixpkgs-unstable;
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
        
          (final: prev: {
            alacritty = prev.alacritty.overrideAttrs (old: rec {
              src = prev.fetchFromGitHub {
                owner = "zenixls2";
                repo = old.pname;
                rev = "3ed043046fc74f288d4c8fa7e4463dc201213500";
                sha256 = "sha256-1dGk4ORzMSUQhuKSt5Yo7rOJCJ5/folwPX2tLiu0suA=";
              };

              # NOTE: don't compile twice
              doCheck = false;

              postInstall = ''
                install -D extra/linux/Alacritty.desktop -t $out/share/applications/
                install -D extra/logo/compat/alacritty-term.svg $out/share/icons/hicolor/scalable/apps/Alacritty.svg
                strip -S $out/bin/alacritty
                patchelf --set-rpath "${
                  prev.lib.makeLibraryPath old.buildInputs
                }:${prev.stdenv.cc.cc.lib}/lib${
                  prev.lib.optionalString prev.stdenv.is64bit "64"
                }" $out/bin/alacritty
                installShellCompletion --zsh extra/completions/_alacritty
                installShellCompletion --bash extra/completions/alacritty.bash
                installShellCompletion --fish extra/completions/alacritty.fish
                install -dm 755 "$out/share/man/man1"
                gzip -c extra/alacritty.man > "$out/share/man/man1/alacritty.1.gz"
                install -Dm 644 alacritty.yml $out/share/doc/alacritty.yml
                install -dm 755 "$terminfo/share/terminfo/a/"
                tic -xe alacritty,alacritty-direct -o "$terminfo/share/terminfo" extra/alacritty.info
                mkdir -p $out/nix-support
                echo "$terminfo" >> $out/nix-support/propagated-user-env-packages
              '';

              cargoDeps = old.cargoDeps.overrideAttrs (_: {
                inherit src;
                outputHash = "sha256-Oc5DdthZqSd0Dc6snE3/WAa19+vOe6wkXkR8d6uPWJo=";
              });
            });
          })
      ];

      hostDefaults.modules = [ utils.nixosModules.saneFlakeDefaults ];
    };
}

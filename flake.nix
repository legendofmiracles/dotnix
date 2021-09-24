{
  description = "LegendOfMiracles's system config";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #local-nixpkgs.url = "git+file://./nixpkgs?ref=fabric";

    home-manager.url = "github:nix-community/home-manager";
    # home-manager.url = "/home/nix/home-manager";

    nur = {
      url = "github:nix-community/NUR";
      #inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";

    nix-gaming.url = "github:fufexan/nix-gaming";

    /* nixpkgs-mozilla = {
         url = github:mozilla/nixpkgs-mozilla;
         flake = false;
       };
    */

    /* npmlock2nix = {
         url = github:tweag/npmlock2nix;
         flake = false;
       };
    */

    darwin.url = "github:lnl7/nix-darwin";
  };

  outputs = { self, nixpkgs # , local-nixpkgs
    , home-manager, utils, nur, nixos-hardware
    # , neovim-nightly
    , agenix, nix-gaming, darwin }@inputs:
    utils.lib.mkFlake {
      inherit self inputs;

      nixosModules = utils.lib.exportModules [
        # the modules
        ./modules/espanso-m.nix
        ./modules/discord-message-sender.nix
        ./modules/cowsay.nix
        ./modules/binfmt.nix
        #./modules/weylus.nix
        # my config
        ./xorg.nix
        ./hm/proton.nix
        ./hm/xorg-hm.nix
        ./hm/mangohud.nix
        ./hm/qt.nix
        ./hm/espanso.nix
        ./hm/dunst.nix
        ./hm/defaults.nix
        ./hm/git.nix
        ./hm/gtk.nix
        ./hm/mpv.nix
        ./hm/fish.nix
        ./hm/htop.nix
        ./hm/nvim.nix
        ./hm/pass.nix
        ./hm/shell-scripts.nix
        ./hm/mori.nix
        ./hm/neofetch.nix
        ./hm/alacritty.nix
        ./defaults-nixos.nix
        ./hm/firefox.nix
        ./v4l2.nix
        ./distributed-build-host.nix
        ./network.nix
        ./hm/newsboat.nix
        ./printer.nix
        ./fonts.nix
        ./hm/aw.nix
      ];

      hostDefaults = {
        modules = [
          agenix.nixosModules.age
          self.nixosModules.defaults-nixos
          #./boot-config.nix
        ];
        extraArgs = {
          inherit utils inputs # naersk nixpkgs-mozilla npmlock2nix
          ;
        };
      };

      channels.nixpkgs = {
        input = nixpkgs;
        config = { allowUnfree = true; };
      };

      hosts = {
        pain = {
          builder = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
          modules = with self.nixosModules; [
            # system wide config
            ./hosts/pain/configuration.nix
            xorg
            v4l2
            nix-gaming.nixosModule
            home-manager.nixosModules.home-manager
            nixos-hardware.nixosModules.common-cpu-intel
            distributed-build-host
            cowsay
            binfmt
            fonts
            network
            #printer
            ({ pkgs, lib, ... }:
              let
                mkDevelopModule = m: {
                  disabledModules = [ m ];
                  imports = [ "${local-nixpkgs}/nixos/modules/${m}" ];
                };
              in {
                # development/testing purposes
                #imports =
                #  [ (mkDevelopModule "services/games/minecraft-server.nix") ];

                /* programs.weylus = {
                     enable = true;
                     users = [ "nix" ];
                   };
                */

                /* services.minecraft-server = {
                     enable = true;
                     eula = true;
                     fabric = {
                       enable = true;
                       version = "1.16.5";
                       mods = [ ./tabtps-fabric-mc1.16.5-1.3.5.jar ];
                     };
                   };
                */

                home-manager.useUserPackages = true;
                home-manager.useGlobalPkgs = true;
                home-manager.users.nix = ({ config, pkgs, lib, ... }:
                  with import ./hm/shell-scripts.nix {
                    inherit pkgs inputs lib;
                  }; {
                    imports = [
                      firefox
                      mangohud
                      git
                      htop
                      defaults
                      alacritty
                      mori
                      dunst
                      mpv
                      xorg-hm
                      pass
                      neofetch
                      qt
                      newsboat
                      #proton
                      #aw
                      fish
                      # my config
                      espanso
                      nvim
                      gtk
                      # the module
                      espanso-m
                    ];

                    home.packages = with pkgs; [
                      # custom shell script
                      zerox0
                      text_from_image
                      auto_clicker
                      nvidia-offload
                      giphsh
                      discord-id
                      rclip
                      command-not-found
                      store-path
                      yt
                      mute

                      helvum
                      /* (osu-nix.packages.x86_64-linux.osu-stable.override {
                           verbose = true;
                         })
                      */
                      ffmpeg
                      lutris
                      obs-studio
                      gimp
                      rpg-cli
                      lucky-commit
                      up
                      nixfmt
                      pavucontrol
                      multimc
                      qrcp
                      tealdeer
                      nix-index
                      bc
                      nvd
                      bat
                      fzf
                      jq
                      manix
                      nix-review
                      imagemagick
                      tmpmail
                      cliscord

                      keymapviz
                      #present
                      autobahn
                      #discover
                      #ab-street
                    ];

                    services.kdeconnect = {
                      enable = true;
                      indicator = true;
                    };

                  });
              })
          ];
        };

        pi = {
          builder = nixpkgs.lib.makeOverridable nixpkgs.lib.nixosSystem;
          system = "aarch64-linux";
          modules = with self.nixosModules; [
            ./hosts/pi/configuration.nix
            discord-message-sender
          ];
        };

        Holgers-iMac = {
          builder = args:
            darwin.lib.darwinSystem (removeAttrs args [ "system" ]);
          system = "x86_64-darwin";
          modules = with self.nixosModules; [
            ./hosts/iMac/configuration.nix

            home-manager.darwinModules.home-manager
            darwin.darwinModules.simple
            ({ pkgs, ... }: {
              home-manager.users.test = ({ config, pkgs, ... }:
                with import ./hm/shell-scripts.nix { inherit pkgs inputs; }; {
                  imports = [ defaults htop fish nvim git ];

                  home.packages = with pkgs; [
                    zerox0
                    store-path
                    command-not-found

                  ];
                });
            })
          ];
          output = "darwinConfiguration";
        };
      };

      sharedOverlays = [
        nur.overlay
        # neovim-nightly.overlay
        self.overlay
        /* (final: prev: {
             naerskUnstable = let
               nmo = import nixpkgs-mozilla final prev;
               rust = (nmo.rustChannelOf {
                 date = "2021-01-27";
                 channel = "nightly";
                 sha256 = "447SQnx5OrZVv6Na5xbhiWoaCwIUrB1KskyMOQEDJb8=";
               }).rust;
             in naersk.lib.x86_64-linux.override {
               cargo = rust;
               rustc = rust;
             };

             npmlock2nix = import npmlock2nix { pkgs = prev; };

             inherit (prev.callPackages ./overlays/activitywatch { })
               aw-core aw-server-rust aw-qt aw-watcher-afk aw-watcher-window
               aw-webui;
           })
        */
      ];

      packagesBuilder = channels: {
        inherit (channels.nixpkgs)
          alacritty-ligatures # neovim-nightly
          #activitywatch
          # aw-qt aw-core aw-server-rust aw-watcher-afk aw-watcher-window aw-webui
          lucky-commit cliscord st-patched # steam-patched
          keymapviz mori espanso-no-notify discover autobahn present ab-street;
      };

      overlay = import ./overlays;
    };
}

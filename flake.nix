{
  description = "LegendOfMiracles's system config";

  inputs = {
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "git+file:///home/lom/nixpkgs?ref=nixos-unstable";
    #nixpkgs.url = "git+file:///home/lom/nixpkgs?ref=upddate-nodjs-asf";

    home-manager.url = "github:nix-community/home-manager";
    # home-manager.url = "/home/nix/home-manager";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = "github:ryantm/agenix";

    nix-gaming.url = "github:fufexan/nix-gaming";

    nixvim = {
      url = "github:pta2002/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, ... }@inputs: {
    inherit self inputs;

    nixosModules = {
      choice = import ./modules inputs;

      config = {
        nixos = {
          xorg = import ./xorg.nix;
          defaults = import ./defaults-nixos.nix;
          v4l2 = import ./v4l2;
          remote-build-host = import ./distributed-build-host.nix;
          network = import ./network.nix;
          printer = import ./printer.nix;
          fonts = import ./fonts.nix;
        };

        hm = {
          proton = import ./hm/proton.nix;
          xorg = import ./hm/xorg-hm.nix;
          mangohud = import ./hm/mangohud.nix;
          qt = import ./hm/qt.nix;
          espanso = import ./hm/espanso.nix;
          dunst = import ./hm/dunst.nix;
          defaults = import ./hm/defaults.nix;
          git = import ./hm/git.nix;
          gtk = import ./hm/gtk.nix;
          mpv = import ./hm/mpv.nix;
          fish = import ./hm/fish.nix;
          htop = import ./hm/htop.nix;
          nvim = import ./hm/nvim.nix;
          pass = import ./hm/pass.nix;
          scripts = import ./hm/shell-scripts.nix;
          mori = import ./hm/mori.nix;
          neofetch = import ./hm/neofetch.nix;
          alacritty = import ./hm/alacritty.nix;
          firefox = import ./hm/firefox.nix;
          newsboat = import ./hm/newsboat.nix;
          aw = import ./hm/aw.nix;
        };
      };
    };

    homeConfigurations = let pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
    in {
      wsl = inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = with self.nixosModules.config.hm; [
          {
            home = {
              stateVersion = "22.05";
              homeDirectory = "/home/lom";
              username = "lom";
              packages = with pkgs;
                with import ./hm/shell-scripts.nix {
                  inherit pkgs inputs lib;
                }; [
                  zerox0
                  giphsh
                  discord-id
                  rclip
                  command-not-found
                  yt
                  hstrace

                  hydra-check
                  lucky-commit
                  up
                  nixfmt
                  pavucontrol
                  tealdeer
                  nix-index
                  bc
                  nvd
                  bat
                  fzf
                  jq
                  nix-review
                  ouch
                  tmpmail

                  keymapviz
                ];
            };
          }
          git
          htop
          defaults
          pass
          neofetch
          newsboat
          fish
          inputs.nixvim.homeManagerModules.nixvim
          nvim
        ];
      };
    };

    nixosConfigurations = {
      pain = inputs.nixpkgs.lib.makeOverridable inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

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
          fonts
          network
          #printer
          ({ pkgs, lib, ... }:
            let
              mkDevelopModule = i: m: {
                disabledModules = [ m ];
                imports = [ "${i}/nixos/modules/${m}" ];
              };
            in {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users.nix = { pkgs, lib, ... }:
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
                    #mori
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
                    inputs.nixvim.homeManagerModules.nixvim
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
                    hstrace

                    helvum
                    tmux
                    hydra-check
                    ffmpeg
                    lutris
                    obs-studio
                    gimp
                    lucky-commit
                    up
                    nixfmt
                    pavucontrol
                    (polymc.override {
                      msaClientID = "01524508-0110-46fc-b468-362d31ca41e6";
                    })
                    copyq
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
                    ouch
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

                };
            })
        ];
      };

      pi = inputs.nixpkgs.lib.makeOverridable inputs.nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = with self.nixosModules; [
          ./hosts/pi/configuration.nix
          config.nixos.defaults
          inputs.agenix.nixosModules.default
          choice.discord-message-sender
        ];
      };

      pi-kb =
        inputs.nixpkgs.lib.makeOverridable inputs.nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          modules = with self.nixosModules; [
            ({ config, pkgs, ... }: { nixpkgs.overlays = [ self.overlays.default ]; })
            ./hosts/pi-kb/configuration.nix
            config.nixos.defaults
            inputs.agenix.nixosModules.default
            #choice.photoprism-mod
          ];
        };
    };

    /* outputsBuilder = channels: {
         packages = utils.lib.exportPackages self.overlays channels;
       };
    */

    overlays.default = import ./overlays;

    devShells.x86_64-linux.default = inputs.nixpkgs.legacyPackages.x86_64-linux.mkShell {
        name = "Secrets shell";
        buildInputs = [
          inputs.agenix.packages.x86_64-linux.agenix
        ];
        EDITOR = "nvim";
      };
  };
}

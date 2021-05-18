{
  description = "LegendOfMiracles's system config";

  inputs = {
    nixos-hardware.url = github:NixOS/nixos-hardware;
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    neovim-nightly.url = github:nix-community/neovim-nightly-overlay;
    # nixpkgs-cloned.url = "/home/nix/nixpkgs/";
    home-manager.url = github:nix-community/home-manager;
    nur = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = github:ryantm/agenix;
    utils.url = github:gytis-ivaskevicius/flake-utils-plus/staging;
  };

  outputs = { self, nixpkgs, home-manager, utils, nur, nixos-hardware, neovim-nightly, agenix }@inputs:
    utils.lib.systemFlake {
      inherit self inputs;

      nixosModules = utils.lib.modulesFromList [
        ./xorg.nix
        ./HM/proton.nix
        ./HM/xorg-hm.nix
        ./HM/qt.nix
        ./HM/dunst.nix
        ./HM/defaults.nix
        ./HM/git.nix
        ./HM/gtk.nix
        ./HM/mpv.nix
        ./HM/fish.nix
        ./HM/htop.nix
        ./HM/nvim.nix
        ./HM/pass.nix
        ./HM/shell-scripts.nix
        ./HM/neofetch.nix
        ./HM/alacritty.nix
        ./HM/firefox.nix
        ./v4l2.nix
        ./network.nix
        ./defaults-nixos.nix
        ./printer.nix
      ];

      hostDefaults = {
        modules = [
          utils.nixosModules.saneFlakeDefaults
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          self.nixosModules.defaults-nixos
        ];
        extraArgs = { inherit utils inputs; };
      };

      channels.nixpkgs = {
        input = nixpkgs;
        config = {
          allowUnfree = true;
        };
      };

      channels.nixpkgs-unstable = {
        input = nixpkgs;
      };

      hosts = {
        pain = {
          modules = with self.nixosModules; [
            # system wide config
            ./hosts/pain/configuration.nix
            xorg
            v4l2
            nixos-hardware.nixosModules.common-cpu-intel
            network
            printer
            ({ pkgs, ... }: {
              age.secrets.variables = {
                file = ./secrets/variables.age;
                owner = "nix";
                mode = "0700";
              };
              age.secrets.wpa = {
                file = ./secrets/wpa_supplicant.conf.age;
                mode = "0700";
              };
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users.nix = ({ config, pkgs, ... }:
                with import ./HM/shell-scripts.nix { inherit pkgs; }; {
                  imports = [
                    firefox
                    git
                    htop
                    alacritty
                    dunst
                    mpv
                    xorg-hm
                    pass
                    neofetch
                    qt
                    proton
                    fish
                    nvim
                    defaults
                    gtk
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

                    languagetool
                    nixpkgs-fmt
                    lolcat
                    copyq
                    cascadia-code
                    glxinfo
                    xclip
                    ncdu
                    weechat
                    noisetorch
                    pandoc
                    unzip
                    ytfzf
                    ungoogled-chromium
                    libnotify
                    tesseract
                    maim
                    hyperfine
                    ffmpeg
                    lutris
                    xorg.xkill
                    hyperfine
                    obs-studio
                    git-lfs
                    cowsay
                    feh
                    gimp
                    legendary-gl
                    pavucontrol
                    xorg.xev
                    multimc
                    jq
                    grit
                    qrcp
                    nix-review
                    libnotify
                    xdotool
                    imagemagick
                    asciigraph
                    grex
                    tmpmail
                    giph
                    pastel
                  ];
                });
              environment.shellAliases = {
                nix-repl = "nix repl ${inputs.utils.lib.repl}";
              };
            })
          ];
        };
        pi = {
          system = "aarch64-linux";
          modules = with self.nixosModules; [
            # system wide config
            ./hosts/pi/configuration.nix
            network
            ({ pkgs, ... }: {
              age.secrets.variables = {
                file = ./secrets/variables.age;
                owner = "nix";
                mode = "0700";
              };
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users.nix = ({ config, pkgs, ... }:
                with import ./HM/shell-scripts.nix { inherit pkgs; }; {
                  imports = [
                    git
                    htop
                    fish
                    nvim
                    defaults
                  ];

                  home.packages = with pkgs; [
                    # custom shell script
                    zerox0

                    nixpkgs-fmt
                    ncdu
                    unzip
                    jq
                  ];
                });
              environment.shellAliases = {
                nix-repl = "nix repl ${inputs.utils.lib.repl}";
              };
            })
          ];
        };
      };

      sharedOverlays = [
        nur.overlay
        neovim-nightly.overlay
        self.overlay
      ];

      packagesBuilder = channels: {
        inherit (channels.nixpkgs)
          alacritty-ligatures
          neovim-nightly;
      };

      appsBuilder = channels: with channels.nixpkgs; {
        alacritty-ligatures = utils.lib.mkApp {
          drv = alacritty-ligatures;
          exePath = "/bin/alacritty";
        };
        /*nvim-n = utils.lib.mkApp {
          drv = neovim-nightly;
          exePath = "/bin/nvim";
          };*/
      };


      overlay = import ./overlays;
    };
}

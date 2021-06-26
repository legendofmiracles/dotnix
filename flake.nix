{
  description = "LegendOfMiracles's system config";

  inputs = {
    nixos-hardware.url = github:NixOS/nixos-hardware;

    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    # nixpkgs.url = "/home/nix/nixpkgs/";

    neovim-nightly.url = github:nix-community/neovim-nightly-overlay;

    home-manager.url = github:nix-community/home-manager;
    # home-manager.url = "/home/nix/home-manager";
    nur = {
      url = github:nix-community/NUR;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    naersk = {
      url = github:nmattia/naersk;
      inputs.nixpkgs.follows = "nixpkgs";
    };

    agenix.url = github:ryantm/agenix;

    utils.url = github:gytis-ivaskevicius/flake-utils-plus/staging;

    osu-nix.url = github:fufexan/osu.nix;

    nixpkgs-mozilla = {
      url = github:mozilla/nixpkgs-mozilla;
      flake = false;
    };

    npmlock2nix = {
      url = github:tweag/npmlock2nix;
      flake = false;
    };
  };

  outputs = { self, nixpkgs, home-manager, utils, nur, nixos-hardware
    , neovim-nightly, agenix, naersk, nixpkgs-mozilla, npmlock2nix, osu-nix }@inputs:
    utils.lib.systemFlake {
      inherit self inputs;

      nixosModules = utils.lib.modulesFromList [
        ./HM/test.nix
        ./xorg.nix
        ./HM/proton.nix
        ./HM/xorg-hm.nix
        ./HM/qt.nix
        # the module
        ./espanso-m.nix
        ./HM/dunst.nix
        # my config
        ./HM/espanso.nix
        ./HM/defaults.nix
        ./HM/git.nix
        ./HM/gtk.nix
        ./HM/mpv.nix
        ./HM/fish.nix
        ./HM/htop.nix
        ./HM/nvim.nix
        ./HM/pass.nix
        ./HM/shell-scripts.nix
        ./HM/mori.nix
        ./HM/neofetch.nix
        ./HM/alacritty.nix
        ./HM/firefox.nix
        ./v4l2.nix
        ./network.nix
        ./HM/newsboat.nix
        ./defaults-nixos.nix
        ./printer.nix
        ./fonts.nix
        ./cowsay.nix
        ./HM/aw.nix
      ];

      hostDefaults = {
        modules = [
          utils.nixosModules.saneFlakeDefaults
          home-manager.nixosModules.home-manager
          agenix.nixosModules.age
          self.nixosModules.defaults-nixos
        ];
        extraArgs = {
          inherit utils inputs naersk nixpkgs-mozilla npmlock2nix;
        };
      };

      channels.nixpkgs = {
        input = nixpkgs;
        config = { allowUnfree = true; };
      };

      channels.nixpkgs-unstable = { input = nixpkgs; };

      hosts = {
        pain = {
          modules = with self.nixosModules; [
            # system wide config
            ./hosts/pain/configuration.nix
            xorg
            v4l2
            osu-nix.nixosModule
            nixos-hardware.nixosModules.common-cpu-intel
            cowsay
            fonts
            network
            printer
            ({ pkgs, ... }: {

              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
              home-manager.users.nix = ({ config, pkgs, ... }:
                with import ./HM/shell-scripts.nix { inherit pkgs; }; {
                  imports = [
                    firefox
                    git
                    htop
                    alacritty
                    mori
                    dunst
                    mpv
                    xorg-hm
                    pass
                    neofetch
                    qt
                    newsboat
                    test
                    proton
                    #aw
                    fish
                    # my config
                    espanso
                    nvim
                    defaults
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

                    helvum
                    (osu-nix.packages.x86_64-linux.osu-stable.override { verbose = true; })
                    ffmpeg
                    lutris
                    obs-studio
                    gimp
                    lucky-commit
                    legendary-gl
                    pavucontrol
                    multimc
                    jq
                    qrcp
                    nix-review
                    imagemagick
                    tmpmail

                    keymapviz
                  ];

                  /*systemd.user.services.wednesday = {
                    Unit = { Description = "it's wednesday my dudes"; };

                    Service = {
                      Type = "simple";
                      EnvironmentFile = "/run/secrets/variables";
                      ExecStart = ''
                        ${pkgs.cliscord}/bin/cliscord -s "Best Server" -c main -m "<:wednesday:806483241045196841> It's Wednesday my dudes!" -t $DISCORD_TOKEN'';
                      Restart = "on-failure";
                      RestartSec = 10;
                    };
                  };

                  systemd.user.timers.wednesday = {
                    Unit = { Description = "it's wednesday my dudes"; };

                    Timer = {
                      OnCalendar = "Wed *-*-* 00:00:00";
                      Unit = "wednesday.service";
                    };

                    Install = {
                      WantedBy = [
                        "timers.target"
                      ]; # After = [ "network-online.target" ]; Wants= [ "network-online.target" ];
                    };
                  };
                  */
                });
              environment.shellAliases = {
                nix-repl = "nix repl ${inputs.utils.lib.repl}";
                mangohud =
                  "LD_LIBRARY_PATH=/run/opengl-driver/lib ${pkgs.mangohud}/bin/mangohud";
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
              home-manager.users.nix = ({ config, pkgs, ... }:
                with import ./HM/shell-scripts.nix { inherit pkgs; }; {
                  imports = [
                    git
                    htop
                    fish
                    defaults
                  ];

                  home.packages = with pkgs; [
                    # custom shell script
                    zerox0

                    nixpkgs-fmt
                    ncdu
                    unzip
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
        /*
        (final: prev: {
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
          alacritty-ligatures neovim-nightly
          # aw-qt aw-core aw-server-rust aw-watcher-afk aw-watcher-window aw-webui
          lucky-commit cliscord st-patched steam-patched keymapviz mori espanso-no-notify;
      };

      overlay = import ./overlays;
    };
}

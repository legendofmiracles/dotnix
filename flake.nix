{
  description = "LegendOfMiracles's system config";

  inputs = {
    nixos-hardware.url = github:NixOS/nixos-hardware;
    nixpkgs.url = github:nixos/nixpkgs/nixos-unstable;
    neovim-nightly.url = github:nix-community/neovim-nightly-overlay;
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # nixpkgs-cloned.url = "file:/home/nix/nixpkgs/";
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
        ./secrets/wifi.nix
        ./xorg.nix
        ./HM/proton.nix
        ./HM/xorg-hm.nix
        ./HM/qt.nix
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
      ];

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
            wifi
            home-manager.nixosModules.home-manager
            agenix.nixosModules.age
            {
              home-manager.useUserPackages = true;
              home-manager.useGlobalPkgs = true;
            }
            ({ pkgs, ... }: {
              # home-manager config because
              home-manager.users.nix = ({ config, pkgs, ... }:
                with import ./HM/shell-scripts.nix { inherit pkgs; }; {
                  imports = [
                    firefox
                    git
                    htop
                    alacritty
                    mpv
                    xorg-hm
                    pass
                    neofetch
                    qt
                    proton
                    fish
                    nvim
                    /home/nix/dotnix/secrets/variables.nix
                    defaults
                    gtk
                  ];

                  home.packages = with pkgs; [
                    # custom shell script
                    zerox0
                    text_from_image
                    auto_clicker
                    rnix
                    nvidia-offload
                    giphsh
                    discord-id
                    rclip

                    languagetool
                    nixpkgs-fmt
                    lolcat
                    # i know.. microsoft's font ;-;
                    cascadia-code
                    glxinfo
                    xclip
                    ncdu
                    weechat
                    noisetorch
                    pandoc
                    mpv
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
                    xcolor

                    # Last line
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

{ config, pkgs, ... }:
with import ./shell-scripts.nix { inherit pkgs; };
{
  imports = [
    ./firefox.nix
    ./git.nix
    ./htop.nix
    ./alacritty.nix
    ./mpv.nix
    ./i3.nix
    ./pass.nix
    ./neofetch.nix
    ./qt.nix
    ./proton.nix
    ./fish.nix
    ./nvim.nix
    /home/nix/dotnix/secrets/variables.nix
    ./gtk.nix
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

    htop
    fzf
    languagetool
    nixpkgs-fmt
    lolcat
    bat
    tree
    # i know.. microsoft's font ;-;
    cascadia-code
    glxinfo
    cordless
    xclip
    ncdu
    weechat
    noisetorch
    pandoc
    file
    rnix-lsp
    mpv
    unzip
    ytfzf
    ungoogled-chromium
    libnotify
    tesseract
    maim
    hyperfine
    zip
    ffmpeg
    fd
    lutris
    xorg.xkill
    hyperfine
    obs-studio
    git-lfs
    ripgrep-all
    hack-font
    font-awesome
    nix-index
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
    zip
    libnotify
    wget
    nix-index
    ripgrep
    xdotool
    tldr
    imagemagick
    asciigraph
    grex
    bc
    tmpmail
    giph
    xcolor
    # Last line
  ];

  services.dunst.enable = true;
  #services.dunst.settings = ''

  #'';

  home.stateVersion = "21.05";
  # home.stateVersion = "20.09";
}

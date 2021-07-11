{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    manix
    jq
    fzf
    bat
    delta
    tree
    nvd
    up
    rpg-cli
    nixfmt
    wget
    rnix-lsp
    sl
    gh
    ripgrep
    tldr
    nix-index
    bc
    file
    fd
    zip
    thefuck
  ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = false;
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
      enableFlakes = true;
    };
  };

  home.username = "nix";
  home.homeDirectory = "/home/nix";

  news.display = "silent";
}

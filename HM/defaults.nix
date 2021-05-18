{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    manix
    fzf
    bat
    delta
    tree
    up
    wget
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

  programs.direnv =
    {
      enable = true;
      enableNixDirenvIntegration = true;
    };

  home.username = "nix";
  home.homeDirectory = "/home/nix";

  news.display = "silent";
}

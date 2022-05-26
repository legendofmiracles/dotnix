{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ tree wget ripgrep file fd zip ];

  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      createDirectories = false;
      desktop = "/tmp/desktop";
    };
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv = {
    enable = true;
    nix-direnv = { enable = true; };
  };

  #home.username = "nix";
  #home.homeDirectory = "/home/nix";

  news.display = "silent";
}

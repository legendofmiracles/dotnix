{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    htop
    fzf
    bat
    tree
    wget
    ripgrep
    tldr
    nix-index
    bc
    file
    fd
    cachix
    zip
    thefuck
  ];

  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = false;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;
  programs.direnv.stdlib = ''
    use_flake() {
      watch_file flake.nix
      watch_file flake.lock
      eval "$(nix print-dev-env --profile "$(direnv_layout_dir)/flake-profile")"
    }
  '';

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nix";
  home.homeDirectory = "/home/nix";

  news.display = "silent";
}

{ config, pkgs, ... }:
with import ./shell-scripts.nix { inherit pkgs; };
{
  imports = [
    ./firefox.nix
    ./i3.nix
    ./fish.nix
    ./nvim.nix
  ];
  xdg.userDirs.enable=false;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
  services.flameshot.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    # custom shell script
    zerox0
    text_from_image
    auto_clicker
    rnix

    htop
    fzf
    languagetool
    nixpkgs-fmt
    lolcat
    manix
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
    rust-analyzer
    hyperfine
    zip
    ffmpeg
    fd
    lutris
    xorg.xkill
    hyperfine
    obs-studio
    git-lfs
    ripgrep
    hack-font
    font-awesome
    nix-index
    colorpicker
    tiramisu
    cowsay
    feh
    gimp
    legendary-gl
    pavucontrol
    xorg.xev
    multimc
    jq
    grit
    # Last line
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  programs.git.enable = true;
  programs.git.userName = "legendofmiracles";
  programs.git.userEmail = "legendofmiracles@protonmail.com";
  programs.git.signing.key = "CC50 F82C 985D 2679 0703  AF15 19B0 82B3 DEFE 5451";
  programs.git.signing.signByDefault = true;
  programs.git.aliases = {
    "lg" = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
    "gud" = "commit -am";
  };

  programs.direnv.enable = true;
  programs.direnv.enableNixDirenvIntegration = true;

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "nix";
  home.homeDirectory = "/home/nix";

  programs.password-store.enable = true;
  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "firefox" ];

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "curses";

  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    env = {
      TERM = "xterm-256color";
    };
    font = {
      normal = {
        family = "Cascadia Code PL";
        style = "Regular";
      };
      bold = {
        family = "Cascadia Code PL";
        style = "Bold";
      };
      italic = {
        family = "Cascadia Code PL";
        style = "Italic";
      };
      bold_italic = {
        family = "Cascadia Code PL";
        style = "Bold Italic";
      };
      size = 8;
    };
    cursor = {
      style = "Underline";
      unfocused_hollow = true;
    };
    mouse.url.launcher = {
      program = "firefox";
    };
  };

  home.stateVersion = "21.05";

}

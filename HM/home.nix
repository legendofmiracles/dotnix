{ config, pkgs, ... }:
with import ./shell-scripts.nix { inherit pkgs; };
{
  imports = [
    ./firefox.nix
    ./i3.nix
    ./fish.nix
    ./nvim.nix
    /home/nix/dotnix/secrets/variables.nix
    # ./gtk.nix
  ];

  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = false;
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
    giphsh

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
    qrcp
    nix-review
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

  xdg.configFile."gtk-3.0/settings.ini".text = ''
    [Settings]
    gtk-theme-name=oomox-aaa
    gtk-font-name=Cascadia Mono PL 11
    gtk-application-prefer-dark-theme=false
    gtk-icon-theme-name=Adwaita
    gtk-cursor-theme-name=Adwaita
    gtk-cursor-theme-size=0
    gtk-toolbar-style=GTK_TOOLBAR_BOTH
    gtk-toolbar-icon-size=GTK_ICON_SIZE_LARGE_TOOLBAR
    gtk-button-images=1
    gtk-menu-images=1
    gtk-enable-event-sounds=1
    gtk-enable-input-feedback-sounds=1
    gtk-xft-antialias=1
    gtk-xft-hinting=1
    gtk-xft-hintstyle=hintfull
  '';

  home.stateVersion = "21.05";
}

{ config, pkgs, ... }:
with import ./shell-scripts.nix { inherit pkgs; };
{
  imports = [
    ./firefox.nix
    ./i3.nix
    ./qt.nix
    ./proton.nix
    ./fish.nix
    ./nvim.nix
    /home/nix/dotnix/secrets/variables.nix
    ./gtk.nix
  ];

  xdg.enable = true;
  xdg.userDirs.enable = true;
  xdg.userDirs.createDirectories = false;
  services.flameshot.enable = true;

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
    # custom shell script
    zerox0
    text_from_image
    auto_clicker
    rnix
    nvidia-offload
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
    colorpicker
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

  programs.password-store.enable = true;
  programs.password-store.package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "firefox" ];

  programs.gpg.enable = true;
  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "curses";

  services.dunst.enable = true;
  #services.dunst.settings = ''

  #'';

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

  programs.htop = {
    enable = true;
    detailedCpuTime = true;
    showCpuFrequency = true;
    showCpuUsage = true;
    showProgramPath = false;
    showThreadNames = true;
    meters = {
      left = [ "AllCPUs" "Memory" "Swap" ];
      right = [ "Tasks" "LoadAverage" "Uptime" ];
    };
  };

  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu";
      profile = "gpu-hq";
    };
  };

  news.display = "silent";
  home.stateVersion = "21.05";
  # home.stateVersion = "20.09";
}

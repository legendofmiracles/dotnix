{ pkgs, config, ... }:

with import ./colors.nix { }; {
  programs.alacritty.package = pkgs.alacritty-ligatures;
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
    working_directory = config.home.homeDirectory;
    env = { TERM = "xterm-256color"; };
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
    colors = {
      primary = {
        background = "0xe1e2e7";
        foreground = "0x3760bf";
      };
      normal = {
        black = "0xe9e9ed";
        red = "0xf52a65";
        green = "0x587539";
        yellow = "0x8c6c3e";
        blue = "0x2e7de9";
        magenta = "0x9854f1";
        cyan = "0x007197";
        white = "0x6172b0";
      };
    };
    cursor = {
      style = "Underline";
      unfocused_hollow = true;
    };
    mouse.url.launcher = { program = "firefox"; };
  };
}

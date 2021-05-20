{ pkgs, config, ... }:

with import ./colors.nix { }; {
  programs.alacritty.package = pkgs.alacritty-ligatures;
  programs.alacritty.enable = true;
  programs.alacritty.settings = {
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
        background = "#0F1318";
        foreground = "#C1C0C1";
      };
      normal = {
        black = "#0f1318";
        red = "#5D6165";
        green = pink;
        yellow = pink;
        blue = pink;
        magenta = "#3F38A4";
        cyan = pink;
        white = fg;
      };
    };
    cursor = {
      style = "Underline";
      unfocused_hollow = true;
    };
    mouse.url.launcher = { program = "firefox"; };
  };
}

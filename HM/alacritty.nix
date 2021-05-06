{ pkgs, config, ... }:

{
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
    colors = {
      primary = {
        background = "#0F1318";
        foreground = "#C1C0C1";
      };
      normal = {
        black = "#0f1318";
        red = "#5D6165";
        green = "#FF217C";
        yellow = "#FF217C";
        blue = "#FF217C";
        magenta = "#3F38A4";
        cyan = "#FF217C";
        white = "#c1c0c1";
      };
    };
    cursor = {
      style = "Underline";
      unfocused_hollow = true;
    };
    mouse.url.launcher = {
      program = "firefox";
    };
  };
}

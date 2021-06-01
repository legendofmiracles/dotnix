{ lib, pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      cascadia-code
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Cascadia Code" ];
        monospace = [ "Cascadia Code" ];
      };
    };
  };
}

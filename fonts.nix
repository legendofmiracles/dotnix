{ lib, pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      cascadia-code
      font-awesome
      hack-font
    ];
    fontconfig = {
      enable = true;
      defaultFonts = {
        serif = [ "Cascadia Code" ];
        monospace = [ "Cascadia Code" ];
        sansSerif = [ "Cascadia Code" ];
      };
    };
  };
}

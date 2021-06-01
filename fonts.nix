{ lib, pkgs, ... }:

{
  fonts = {
    fonts = with pkgs; [
      cascadia-code
    ];
    fontconfig = {
      enable = true;
    };
  };
}

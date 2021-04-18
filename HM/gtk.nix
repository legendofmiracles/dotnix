{ config, pkgs, ... }:

let
  font = "Cascadia Mono PL";
in
{
  gtk = {
    enable = true;
    font = {
      name = font;
    };
    theme = {
      package = null;
      name = "oo";
    };
  };
}

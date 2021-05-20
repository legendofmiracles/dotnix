{ pkgs, lib, stdenv, ... }:

{
  qt = {
    enable = true;
    # platformTheme = "gtk";
    style = { name = "adwaita-dark"; };
  };
}

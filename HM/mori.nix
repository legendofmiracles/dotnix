{ lib, pkgs, ... }:

{
  xdg.configFile."mori/mori.json".text = builtins.toJSON {
    osuDir = "~/.osu/";
    sourceDir = "~/Downloads";
  };

  home.packages = [ pkgs.mori ];
}

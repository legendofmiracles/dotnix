{ lib, config, pkgs, ... }:

{
  programs.mpv = {
    enable = true;
    config = {
      hwdec = "auto-safe";
      vo = "gpu";
      profile = "gpu-hq";
    };
    scripts = with pkgs.mpvScripts; [ ];
  };
}

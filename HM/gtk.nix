{ config, pkgs, ... }:

let
  font = "Cascadia Mono PL";
  source = fetchTarball {
    url =
      "https://github.com/legendofmiracles/dots/archive/c31e5d71b40a42cc2c1db6a26b042131e12412a9.tar.gz";
    sha256 = "12p04s9ijr0b79aj93kd8ydhmzzsscbf8w728dz3g23xlb7b1dqa";
  };
in {
  gtk = {
    enable = true;
    font = { name = font; };
    theme = {
      package = null;
      name = "oomox-aaa";
    };
  };
  home.file.gtk = {
    source = "${source}/.themes/oomox-aaa";
    recursive = true;
    target = ".themes/oomox-aaa";
  };
}

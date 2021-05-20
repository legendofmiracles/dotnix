{ lib, pkgs, ... }:

let
  version = "6.8";
  source = fetchTarball {
    url =
      "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}-GE-2/Proton-${version}-GE-2.tar.gz";
    sha256 = "1104bfwqmh9jb76285ym7sz0bfxan8yzm407mvd7rn3f7938rws3";
  };
in {
  home.file.proton-ge-custom = {
    inherit source;
    recursive = true;
    target = ".steam/root/compatibilitytools.d/Proton-${version}-GE-2/";
  };
}

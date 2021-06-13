{ lib, pkgs, ... }:

let
  version = "6.10-GE-1";
  source = fetchTarball {
    url =
      "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/Proton-${version}.tar.gz";
    sha256 = "sha256:0yibri0x6a4xxd8djavlsfap00gnf506r25cxpv50yglvi1a3rr1";
  };
in {
  home.file.proton-ge-custom = {
    inherit source;
    recursive = true;
    target = ".steam/root/compatibilitytools.d/Proton-${version}/";
  };
}

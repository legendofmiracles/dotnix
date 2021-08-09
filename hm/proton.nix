{ lib, pkgs, ... }:

let
  version = "6.14-GE-1";
  source = fetchTarball {
    url =
      "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/Proton-${version}.tar.gz";
    sha256 = "0hg8fqvyikqzxvma6k0ggma2k8l96q9ss5bpyrv2d11n1g1irfvy";
  };
in {
  home.file.proton-ge-custom = rec {
    inherit source;
    recursive = true;
    target = ".steam/root/compatibilitytools.d/Proton-${version}/";
    onChange = "mkdir ${target}/files/share/default_pfx/dosdevices || true";
  };
}

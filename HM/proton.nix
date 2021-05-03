{ lib, pkgs, ... }:

let
  version = "6.5";
  source = fetchTarball {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}-GE-2/Proton-${version}-GE-2.tar.gz";
    sha256 = "1xacwy3a59i0xafc1q5k3yxvkkylh11gjs772rkih6airpgp05vy";
  };
in
{
  home.file.proton-ge-custom = {
    inherit source;
    recursive = true;
    target = ".steam/root/compatibilitytools.d/Proton-${version}-GE-2/";
  };
}

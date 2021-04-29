{ lib, pkgs, ... }:

let source = fetchTarball {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/6.5-GE-2/Proton-6.5-GE-2.tar.gz";
    sha256 = "1xacwy3a59i0xafc1q5k3yxvkkylh11gjs772rkih6airpgp05vy";
  };
in
{
  home.file.proton-ge-custom = {
      inherit source;
      recursive = true;
      target = ".steam/root/compatibilitytools.d/Proton-6.5-GE-2/";
  };
}

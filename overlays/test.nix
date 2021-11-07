{ lib, pkgs, stdenv }:

stdenv.mkDerivation rec {
  pname = "test";
  version = "1.0";

  src = "";

  preBuild = ''
    false
  '';
}

{ lib, stdenvNoCC, fetchFromGitHub, makeWrapper }:

stdenvNoCC.mkDerivation rec {
  pname = "junest";
  version = "7.3.9";

  src = fetchFromGitHub {
    owner = "fsquillace";
    repo = pname;
    rev = version;
    sha256 = "sha256-/WY7J2MrGA0x3Kz/flk7jWSbs9eonYLs/Iz/Y8Grhms=";
  };

  doBuild = false;

  buildInputs = [ makeWrapper ];

  preInstall = ''
    rm -r ci tests
  '';

  installPhase = ''
    mkdir -p $out
    mv * $out/
  '';
}

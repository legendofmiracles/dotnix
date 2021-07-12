{ lib, stdenv, fetchFromGitHub, fzf }:

stdenv.mkDerivation rec {
  pname = "nix-autobahn";
  version = "unstable-2020-12-27";

  src = fetchFromGitHub {
    owner = "Lassulus";
    repo = pname;
    rev = "49b1ac67fc7a683dd82c101715a1548a9a5c7471";
    sha256 = "sha256-X4NTKt5Ro5PLYw15dt663W3Kz+5RcZoFO6vShYoRbrU=";
  };

  buildInputs = [ fzf ];

  doCheck = false;
  doBuild = false;

  installPhase = ''
    mkdir -p $out/bin/
    cp ./nix-autobahn $out/bin/
    cp ./fhs-shell $out/bin/
    cp ./find-libs $out/bin/
  '';

  meta = with lib; {
    maintainers = with maintainers; [ legendofmiracles ];
    mainProgram = "nix-autobahn";
  };
}

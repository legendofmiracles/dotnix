{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, dune-common, dune-geometry }:

stdenv.mkDerivation rec {
  pname = "dune-istl";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "dune-project";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-d69xi8Z9IG6uptooiDSM/bLEwbqnGhM02U7XTH6RNgc=";
  };

  nativeBuildInputs = [ pkg-config dune-common cmake ];

  meta = with lib; { license = licenses.gpl2Only; };
}

{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, dune-common, dune-geometry }:

stdenv.mkDerivation rec {
  pname = "dune-grid";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "dune-project";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-vojYV5ZDnJ1BYX3W4eTI4EY3QNLyObLQcdgUOCjhDCI=";
  };


  nativeBuildInputs = [
    pkg-config
    dune-common
    dune-geometry
    cmake
  ];

  meta = with lib; {
    license = licenses.gpl2Only;
  };
}

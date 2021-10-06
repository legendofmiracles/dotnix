{ lib, stdenv, fetchFromGitHub, cmake, boost, opm-common, dune-common, blas }:

stdenv.mkDerivation rec {
  pname = "opm-material";
  version = "2021.04";

  src = fetchFromGitHub {
    owner = "OPM";
    repo = pname;
    rev = "release/2021.04/final";
    sha256 = "sha256-QsFiB8A273CBlzu8wXACvw1CAu1vllCSStAQd1OXNnw=";
  };

  buildInputs = [ boost opm-common dune-common blas ];

  nativeBuildInputs = [
    cmake
  ];

  postBuild = ''
    make
  '';

  meta = with lib; {
    license = licenses.gpl2Plus;
  };
}

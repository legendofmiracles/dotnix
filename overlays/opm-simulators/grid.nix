{ lib, stdenv, fetchFromGitHub, cmake, dune-common, opm-common, boost, blas, dune-geometry, dune-grid, dune-istl, pkg-config }:

stdenv.mkDerivation rec {
  pname = "opm-grid";
  version = "2021.04";

  src = fetchFromGitHub {
    owner = "OPM";
    repo = pname;
    # have to because otherwise we get deprecation warnings
    rev = "6ad5f7624bd1e2287b1499a20faa319fb0da66c0";
    sha256 = "1q9xsjwc3jd33qlffzb7vdx7wgww14674nisnvffj60xsn4zaq60";
  };

  buildInputs = [ dune-common opm-common boost blas dune-geometry dune-grid dune-istl ];

  preConfigure = ''
    dunecontrol all
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  meta = with lib; {
    license = licenses.gpl2Plus;
  };
}

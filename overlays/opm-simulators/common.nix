{ lib, stdenv, fetchFromGitHub, cmake, boost }:

stdenv.mkDerivation rec {
  pname = "opm-common";
  version = "2021.04";

  src = fetchFromGitHub {
    owner = "OPM";
    repo = "opm-common";
    rev = "release/2021.04/final";
    sha256 = "sha256-ecAHoDo6J31XCk/C+Wu8r5L5GkyQXAh4FVJwdzm0Jyk=";
  };

  buildInputs = [ boost ];

  nativeBuildInputs = [
    cmake
  ];

  postBuild = ''
    make
  '';

  meta = with lib; {
    description = "Common components for OPM, in particular build system (cmake)";
    homepage = "github.com/OPM/opm-common";
    license = licenses.gpl3;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

{ lib, stdenv, fetchFromGitHub, pkg-config, cmake}:

stdenv.mkDerivation rec {
  pname = "dune-common";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "dune-project";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-pIpeev+cc9UnQHpM4OokbAeI/hSgOb7p9NVNgVCXmYI=";
  };


  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  meta = with lib; {
    license = licenses.gpl2Only;
  };
}

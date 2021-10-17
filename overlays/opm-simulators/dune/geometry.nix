{ lib, stdenv, fetchFromGitHub, pkg-config, cmake, dune-common }:

stdenv.mkDerivation rec {
  pname = "dune-geometry";
  version = "2.8.0";

  src = fetchFromGitHub {
    owner = "dune-project";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-BPseYFfx1Nvz0RK3VPAY96lw6HLfpb8aq10BkPxMqz8=";
  };

  nativeBuildInputs = [ pkg-config dune-common cmake ];

  meta = with lib; { license = licenses.gpl2Only; };
}

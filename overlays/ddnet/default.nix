{ lib, stdenv, fetchFromGitHub, freetype, gdk_pixbuf, glib, libglvnd, libnotify
, SDL2, xlibs }:

stdenv.mkDerivation rec {
  pname = "ddnet";
  version = "15.5.4";

  src = fetchFromGitHub {
    owner = "ddnet";
    repo = pname;
    rev = version;
    sha256 = "sha256-CHbadglZMdJcnMU3XVv3Kmz/qTMLN4hjZ4UhAaH5RyY=";
    fetchSubmodules = true;
  };

  buildInputs =
    [ curl freetype gdk_pixbuf glib libglvnd SDL2 xlibs.libX11 libnotify ];

  doBuild = false;

  installPhase = "\n";

  meta = with lib; {
    description = "A cooperative racing mod of Teeworlds";
    homepage = "https://github.com/ddnet/ddnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

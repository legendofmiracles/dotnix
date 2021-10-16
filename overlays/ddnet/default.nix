{ lib
, stdenv
, fetchFromGitHub
, freetype
, gdk_pixbuf
, glib
, libglvnd
, libnotify
, SDL2
, xlibs
, cmake
, ninja
, python3
, pkg-config
, curl
, libGLU
, wavpack
, sqlite
, libogg
, opusfile
, makeWrapper
}:

stdenv.mkDerivation rec {
  pname = "ddnet";
  version = "15.5.4";

  src = fetchFromGitHub {
    owner = "ddnet";
    repo = pname;
    rev = version;
    sha256 = "sha256-vJMYPaLK2CK+nbojLstXgxqIUaf7jNynpklFgtIpvGM=";
  };

  buildInputs =
    [ freetype gdk_pixbuf glib libglvnd SDL2 xlibs.libX11 libnotify python3 curl libGLU wavpack libogg opusfile sqlite ];

  nativeBuildInputs = [ cmake ninja pkg-config makeWrapper ];

  cmakeFlags = [ "-DAUTOUPDATE=OFF" "-GNinja" ];

  postInstall = ''
    wrapProgram $out/bin/DDNet \
    --run "cd $out/share/ddnet/data"

    wrapProgram $out/bin/DDNet-Server \
    --run "cd $out/share/ddnet/data"
  '';

  meta = with lib; {
    description = "A cooperative racing mod of Teeworlds";
    homepage = "https://github.com/ddnet/ddnet";
    license = licenses.asl20;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

{ stdenv, lib, gtk3, fetchzip, autoPatchelfHook, xorg, makeWrapper, glib }:

stdenv.mkDerivation rec {
  pname = "ab-street";
  version = "0.2.58";

  src = fetchzip {
    url = "https://github.com/a-b-street/abstreet/releases/download/v${version}/abstreet_linux_v${lib.strings.stringAsChars (x: if x == "." then "_" else x) version}.zip";
    sha256 = "sha256-uu24Mn0JpZX5mDkPG8wRAXaYCSYVPmk00uvL0dtsKLQ=";
  };

  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];

  buildInputs = [ gtk3 glib xorg.libX11 ];

  doBuild = false;

  installPhase = ''
    install -D game/game $out/bin/ab-street
    wrapProgram $out/bin/ab-street \
      --suffix LD_LIBRARY_PATH : ${xorg.libX11}/lib/libX11-xcb.so.1

    mkdir $out/tools
    cp -r tools $out/tools

    mkdir $out/data
    cp -r data $out/data
  '';

  meta = with lib; {
    description = "A traffic simulation game exploring how small changes to roads affect cyclists, transit users, pedestrians, and drivers.";
    homepage = "github.com/a-b-street/abstreet";
    license = licenses.asl20;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

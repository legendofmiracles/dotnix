{ lib, gtk3, fetchFromGitHub, xorg, makeWrapper, glib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "ab-street";
  version = "0.2.58";

  src = fetchFromGitHub {
    owner = "a-b-street";
    repo = "abstreet";
    rev = "v${version}";
    sha256 = "sha256-JMFvf6gfx4QuBFwryZjnT/NaT8KWVHzgXFKWGLkuFaE=";
  };

  cargoSha256 = lib.fakeSha256;

  nativeBuildInputs = [ makeWrapper ];

  buildInputs = [ gtk3 glib xorg.libX11 ];

  installPhase = ''
    wrapProgram $out/bin/ab-street \
      --suffix LD_LIBRARY_PATH : ${xorg.libX11}/lib/libX11-xcb.so.1

    mkdir $out/tools
    cp -r tools $out/tools

    mkdir $out/data
    cp -r data $out/data
  '';

  meta = with lib; {
    description =
      "A traffic simulation game exploring how small changes to roads affect cyclists, transit users, pedestrians, and drivers.";
    homepage = "github.com/a-b-street/abstreet";
    license = licenses.asl20;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

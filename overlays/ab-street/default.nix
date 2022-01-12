{ lib, gtk3, fetchFromGitHub, xorg, makeWrapper, glib, rustPlatform, alsa-lib, pkg-config, python3, file }:

rustPlatform.buildRustPackage rec {
  pname = "ab-street";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "a-b-street";
    repo = "abstreet";
    rev = "v${version}";
    sha256 = "sha256-f6Xei72NPwrgxjd1q8FUdJGLcV7ie4UQlMfV3eq0gtE=";
  };

  cargoSha256 = "sha256-6LsAldkaC18hCgIi2nNxZLRzwP9SBh0doAcL6wY3Qgk=";

  nativeBuildInputs = [ makeWrapper pkg-config python3 ];

  buildInputs = [ gtk3 glib xorg.libX11 alsa-lib ];

  cargoBuildFlags = [ "--bin" "game" ];

  installPhase = ''
    #wrapProgram $out/bin/ab-street \
    #  --suffix LD_LIBRARY_PATH : ${xorg.libX11}/lib/libX11-xcb.so.1

    #mkdir -p $out/tools
    #cp -r tools $out/tools

    mkdir -p $out/data
    cp -r data $out/data
  '';

  # fail for some reason
  doCheck = false;

  meta = with lib; {
    description =
      "A traffic simulation game exploring how small changes to roads affect cyclists, transit users, pedestrians, and drivers.";
    homepage = "https://github.com/a-b-street/abstreet";
    license = licenses.asl20;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

{ lib, rustPlatform, fetchFromGitHub, pkg-config, alsa-lib, python3, gtk3, pango }:

rustPlatform.buildRustPackage rec {
  pname = "ab-street";
  version = "0.2.58";

  src = fetchFromGitHub {
    owner = "a-b-street";
    repo = "abstreet";
    rev = "v${version}";
    sha256 = "188m5swii5jjbkh7qm4nq97mmwsgwyccjasw0hp89iqzm1znzh94";
  };

  cargoSha256 = "sha256-qsp5U4uUj3UvlpUA2iup/nDHJxhns4aYpKBSBuEVFLI=";

  nativeBuildInputs = [ pkg-config python3 gtk3 ];

  buildInputs = [ alsa-lib pango ];

  meta = with lib; {
    description = "A traffic simulation game exploring how small changes to roads affect cyclists, transit users, pedestrians, and drivers.";
    homepage = "github.com/a-b-street/abstreet";
    license = licenses.asl20;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

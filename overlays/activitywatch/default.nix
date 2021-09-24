{ lib, fetchzip, stdenv }:

stdenv.mkDerivation rec {
  pname = "activitywatch";
  version = "0.11.0";

  src = fetchzip {
    url =
      "https://github.com/ActivityWatch/activitywatch/releases/download/v${version}/activitywatch-v${version}-linux-x86_64.zip";
    sha256 = "sha256-CYLhSxlKMHuIEMmqtN8o/lhwTfcR+DInFxVjZOJ1fHc=";
  };

  installPhase = ''
    ls
  '';

  meta = with lib; {
    description =
      "The best free and open-source automated time tracker. Cross-platform, extensible, privacy-focused";
    homepage = "https://github.com/ActivityWatch/activitywatch";
    license = with licenses; [ mpl20 ];
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

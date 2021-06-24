{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "mori";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "TorchedSammy";
    repo = pname;
    rev = "v${version}";
    sha256 = "1n4a5qyza1y3yfllg7ylgizrvk78dgz2ligvdnpr0w2ba4yw967h";
  };

  vendorSha256 = "sha256-rCv8DFQ21LrsI6gXXWFFA0ogH0c9sT0yZvmO1iEe7hA=";

  meta = with lib; {
    description = "Automatically put osu! related archives in their places.";
    homepage = "https://github.com/TorchedSammy/mori";
    license = licenses.bsd3;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

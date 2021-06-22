{ buildGoModule, fetchFromGitHub, lib }:

buildGoModule rec {
  pname = "mori";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "TorchedSammy";
    repo = pname;
    rev = "v${version}";
    sha256 = "07wz5gjl27bfzpm473l5i01mp9hbhh4q3fg3y3mbps21flmy1890";
  };

  vendorSha256 = null;

  # patches = [ ./vendor.patch ];

  meta = with lib; {
    description = "Automatically put osu! related archives in their places.";
    homepage = "https://github.com/TorchedSammy/mori";
    license = licenses.bsd3;
    maintainers = with maintainers; [ legendofmiracles ];
    platforms = platforms.unix;
  };
}

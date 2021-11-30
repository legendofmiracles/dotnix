{ python3, fetchFromGitHub, ... }:

python3.pkgs.buildPythonPackage rec {
  pname = "nix-bisect";
  version = "0.2.0";
  src = pkgs.fetchFromGitHub {
    owner = "timokau";
    repo = "nix-bisect";
    rev = "v${version}";
    sha256 = "0rg7ndwbn44kximipabfbvvv5jhgi6vs87r64wfs5by81iw0ivam";
  };
}

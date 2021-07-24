{ st, fetchFromGitHub, lib, stdenv, harfbuzz, ... }:

(st.overrideAttrs (old: rec {
  src = fetchFromGitHub {
    owner = "legendofmiracles";
    repo = old.pname;
    rev = "487773ec0cb2b8515eb6cbd7b3fd9dc15e0c1547";
    sha256 = "sha256-Fl9vrG8os5p6nN/XK9EpdNqtK3Ocfh3b42yRyqUN4IE=";
  };

  doCheck = false;

  buildInputs = old.buildInputs ++ [ harfbuzz ];
}))

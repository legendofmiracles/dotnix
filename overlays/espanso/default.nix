{ espanso, lib, stdenv, libX11, libXtst, libXi, xclip, openssl, xdotool, ... }:

(espanso.overrideAttrs (old: rec {
  buildInputs = [ libX11 libXtst libXi xclip openssl xdotool ];

  postInstall = ''
    wrapProgram $out/bin/espanso \
      --prefix PATH : ${lib.makeBinPath [ xclip ]}
  '';
}))

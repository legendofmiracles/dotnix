{ lib, fetchzip, steam-run, stdenv, makeDesktopItem, copyDesktopItems, runtimeShell, autoPatchelfHook, ffmpeg, glib, pango, xorg, gtk3, mime-types, nss, mesa }:
let version = "1.1.14";
in stdenv.mkDerivation {
  pname = "gdlauncher";
  inherit version;

  src = fetchzip {
    url =
      "https://github.com/gorilla-devs/GDLauncher/releases/download/v${version}/GDLauncher-linux-setup.zip";
    sha256 = "sha256-xA4t/ZoiZsn2RZokrrKxpcgkL254l4tK1PVM4cgP9dg=";
    stripRoot=false;
  };

  doBuild = false;

  installPhase = ''
    mkdir -p $out/{bin,lib}
    mv gdlauncher $out/bin/gdlauncher
    #cat > $out/bin/gdlauncher <<EOF
    #${runtimeShell}
    #${steam-run}/bin/steam-run $out/bin/.gdlauncher
    #EOF

    chmod 755 $out/bin/gdlauncher

    mv libffmpeg.so $out/lib/

    patchelf --set-rpath ".:${stdenv.cc.libc}/lib" $out/lib/libffmpeg.so
  '';

  nativeBuildInputs = [ copyDesktopItems autoPatchelfHook xorg.libXdamage xorg.libXcomposite ];

  buildInputs = [ ffmpeg glib pango gtk3 mime-types nss xorg.libxshmfence mesa ];

  desktopItems = makeDesktopItem rec {
    name = "GDLauncher";
    exec = "gdlauncher";
    desktopName = name;
    genericName = name;
  };

  meta = with lib; {
    license = licenses.gpl3;
    platforms = [ "i686-linux" "x86_64-linux" ];
  };
}

{ lib, nhi, stdenv, clang, libbpf, ... }:

stdenv.mkDerivation {
  pname = "nhid";
  version = nhi.version;

  src = nhi.src;

  postPatch = ''
    substituteInPlace daemon/src/nhi.c \
      --replace "/etc/nhi/nhi.bpf.o" "{placeholder out}/share/nhi/nhi.bpf.o"
  '';

  buildPhase = ''
    make build-daemon
  '';

  nativeBuildInputs = [ clang ];

  buildInputs = [ libbpf ];

  installPhase = ''
    install -D ./nhid $out/bin/nhid

    install -D ./nhi.bpf.o $out/share/nhi/nhi.bpf.o
  '';

  meta = with nhi.meta; {
    inherit license maintainers homepage;
    # specifically only supports this
    platforms = [ "x86_64-linux" ];
  };
}

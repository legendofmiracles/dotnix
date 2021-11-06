{ lib, rustPlatform, stdenv, pkg-config, udev, libclang, fetchFromGitLab }:

rustPlatform.buildRustPackage rec {
  pname = "asusctl";
  version = "4.0.6";

  src = fetchFromGitLab {
    owner = "asus-linux";
    repo = pname;
    rev = version;
    sha256 = "sha256-Rouuycuxpm3tNNP9ThY5dNKHtqzvzQmTLtNDRk6M/lU=";
  };

  cargoSha256 = "sha256-OHg6W4qc3cxMygWfW3OzS3x9aGYocakDxBDZONHV1PI=";

  doCheck = false;

  nativeBuildInputs = [ pkg-config  ];
  buildInputs = [ udev libclang ];

  patchPhase = ''
    sed '/$(INSTALL_PROGRAM)/d' Makefile
  '';

  cargoBuildFlags = [ "--bin" "asusctl" ];

  postInstall = ''
    make install prefix=$out
  '';

  preInstall = ''
    ls target
  '';

  meta = with lib; {
    description = "A control daemon, CLI tools, and a collection of crates for interacting with ASUS ROG laptops";
    homepage = "https://gitlab.com/asus-linxu/asusctl";
    licenses = licenses.MPL20;
  };
}

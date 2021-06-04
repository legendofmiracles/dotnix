{ lib, rustPlatform, opencl-headers, fetchFromGitHub, ocl-icd }:

rustPlatform.buildRustPackage rec {
  pname = "lucky-commit";
  version = "2.0.3";

  src = fetchFromGitHub {
    owner = "not-an-aardvark";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8VBHDq0EGRvNkRWqaOJDv3REjwPQf+g6ryuM3nIKDTQ=";
  };

  # buildInputs = [ ocl-icd opencl-headers ];

  cargoBuildFlags = [ "--no-default-features" ];

  doCheck = false;

  cargoSha256 = "sha256-CTPZ63d5zVNHNvBWANs3vZmnG3RaekTflQbSRGozwyI=";

  meta = with lib; {
    description = "Customize your git commit hashes";
    homepage = "https://github.com/not-an-aardvark/lucky-commit";
    license = licenses.mit;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}


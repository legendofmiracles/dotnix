{ lib, buildGoModule, fetchFromGitHub, sqlite, makeWrapper, installShellFiles }:

buildGoModule rec {
  pname = "nhi";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "strang1ato";
    repo = pname;
    rev = "v${version}";
    sha256 = "1jqyal3ii9zfqf0vckx1lmawdjh8vasjwwxp646059shr0bp6mr8";
  };

  vendorSha256 = "sha256-CLFleo47GcId0Rd3iWnUnDUWUBn6N96MxSZP+bZRhW4=";

  subPackages = [ "." ];

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  postPatch = ''
    substituteInPlace pkg/utils/openDb.go --replace "/var/nhi/db" "/home/nix/.local/share/nhi"
    substituteInPlace daemon/src/sqlite.c --replace "/var/nhi/db" "/home/nix/.local/share/nhi"
  '';

  postInstall = ''
    wrapProgram $out/bin/nhi \
      --run "if [[ ! -f /home/nix/.local/share/nhi ]]; then touch /home/nix/.local/share/nhi && ${sqlite}/bin/sqlite3 /home/nix/.local/share/nhi  \"PRAGMA journal_mode=WAL; CREATE TABLE IF NOT EXISTS meta (indicator INTEGER, name TEXT, start_time INTEGER, finish_time INTEGER);\"; fi"

    mkdir -p $out/etc
    cp shell/nhi.{bash,zsh} $out/etc/
  '';

  meta = with lib; {
    description = "Automatically capture all potentially useful information about each executed command (as well as its output) and get powerful querying mechanism";
    homepage = "https://github.com/strang1ato/nhi";
    license = licenses.gpl3;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

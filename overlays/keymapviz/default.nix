{ fetchFromGitHub, lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "keymapviz";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "yskoht";
    repo = pname;
    rev = "d6ad57db4c84b5959c96bd6cc9c132522148df47";
    sha256 = "sha256-j9FZyvqcpn1q4hx6yK0tJiUsZhjed9jlPiOegJ4FKzE=";
  };

  propagatedBuildInputs = with python3.pkgs; [ regex ];

  meta = with lib; {
    description = "qmk keymap.c visualizer";
    homepage = "https://github.com/yskoht/keymapviz";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

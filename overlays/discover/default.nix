{ fetchFromGitHub, lib, python3 }:

python3.pkgs.buildPythonApplication rec {
  pname = "discover";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "trigg";
    repo = pname;
    rev = "v${version}";
    sha256 = "09h9cfa6ra5iyslcj5gpd9wmbmz5w3m3raddqbyvncwk6vq6vp0a";
  };

  propagatedBuildInputs = with python3.pkgs; [ pygobject3 websocket-client requests pillow ];

  meta = with lib; {
    description = "Yet another discord overlay for linux";
    homepage = "https://github.com/trigg/Discover";
    license = licenses.gpl3Only;
    platforms = platforms.unix;
    maintainers = with maintainers; [ legendofmiracles ];
  };
}

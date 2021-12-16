{ config, pkgs, ... }:

let font = "Cascadia Mono PL";
in {
  gtk = {
    enable = true;
    font = { name = font; };
    theme = {
      package = null;
      name = "oomox-aaa";
    };
  };
  home.file.gtk = {
    source = "${
        pkgs.fetchFromGitHub {
          owner = "legendofmiracles";
          repo = "dots";
          rev = "c31e5d71b40a42cc2c1db6a26b042131e12412a9";
          sha256 = "sha256-CrewzqJ9iDd+Q+Jw5BbT+v8Km0dtjiRVOgtkGZMm4Io=";
        }
      }/.themes/oomox-aaa";
    recursive = true;
    target = ".themes/oomox-aaa";
  };
}

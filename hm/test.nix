{ lib, pkgs, ... }:

let
  source = fetchTarball {
    url =
      "https://github.com/legendofmiracles/dotnix/releases/download/a/test.tar";
    sha256 = "0g4i1zj6c3k5a3ir84iyn9lz8ypphg7dgg91nmrcpz5hfn6jjmiq";
  };
in {
  home.file.test = {
    inherit source;
    recursive = true;
    target = "tesntesntesn/";
  };
}

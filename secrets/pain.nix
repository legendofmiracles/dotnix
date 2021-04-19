{ config, pkgs, lib, ...}:

let
  wifi = builtins.fromJSON (builtins.readFile ./wifis.json);
in
{

}

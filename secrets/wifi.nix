{ config, pkgs, lib, ...}:

let
  wifi = builtins.fromJSON (builtins.readFile ./wifis.json);
in
{
  lib.lists.forEach wifi (
    x: networking.wireless.networks.${x.name}.psk = ${x.psk}
    )
}

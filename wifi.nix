{ config, pkgs, lib, ... }:

let
  wifi = builtins.fromJSON (builtins.readFile age.secrets.wifi.path);
in
{
  networking.wireless.networks = lib.listToAttrs (lib.lists.forEach wifi (x:
    {
      name = x.name;
      value = { psk = x.psk; };
    }
  )
  );
}

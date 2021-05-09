{ config, pkgs, lib, ... }:

let
  wifi = builtins.fromJSON (builtins.readFile age.secrets.wifi.path);
  # path = builtins.getEnv "NIXOS_CONFIG" + "wifis.json";
in
{
  age.secrets.wifi.file = ./wifi.json.age;
  networking.wireless.networks = lib.listToAttrs (lib.lists.forEach wifi (x:
    {
      name = x.name;
      value = { psk = x.psk; };
    }
  )
  );
}

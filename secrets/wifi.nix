{ config, pkgs, lib, ... }:

let
  wifi = builtins.fromJSON (builtins.readFile /home/nix/dotnix/secrets/wifis.json);
  # path = builtins.getEnv "NIXOS_CONFIG" + "wifis.json";
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

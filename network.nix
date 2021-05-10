{ config, pkgs, lib, ... }:

{
  networking = {
    wireless = {
      enable = true;
      #networks = lib.listToAttrs (lib.lists.forEach (builtins.fromJSON (builtins.readFile config.age.secrets.wifi.path)) (x:
      #  {
      #    name = x.name;
      #    value = { psk = x.psk; };
      #  }
      #)
      #);
    };
    useDHCP = false;
    interfaces = {
      enp8s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
    nameservers = [ "1.1.1.1" ];
  };
}

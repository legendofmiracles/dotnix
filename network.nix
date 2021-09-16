{ config, pkgs, lib, ... }:

{
  networking = {
    wireless = { enable = false; };
    useDHCP = false;
    nameservers = [ "1.1.1.1" ];
  };
  #environment.etc."wpa_supplicant.conf".source = config.age.secrets.wpa.path;
}

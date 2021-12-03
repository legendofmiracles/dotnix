{ config, pkgs, lib, ... }:

{
  networking = {
    wireless = { enable = false; };
    useDHCP = false;
    nameservers = [ "9.9.9.9" ];
  };
  #environment.etc."wpa_supplicant.conf".source = config.age.secrets.wpa.path;
}

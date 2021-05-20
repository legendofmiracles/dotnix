{ config, pkgs, lib, ... }:

{
  networking = {
    wireless = { enable = true; };
    useDHCP = false;
    nameservers = [ "1.1.1.1" ];
  };
  environment.etc."wpa_supplicant.conf".source = config.age.secrets.wpa.path;
}

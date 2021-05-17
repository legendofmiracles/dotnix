{ config, pkgs, lib, ... }:

{
  networking = {
    wireless = {
      enable = true;
    };
    useDHCP = false;
    interfaces = {
      enp8s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
    nameservers = [ "1.1.1.1" ];
  };
  environment.etc."wpa_supplicant.conf".source = config.age.secrets.wpa.path;
}

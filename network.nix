{ config, pkgs, lib, ... }:

{
  networking = {
    wireless = {
      enable = true;
    };
    useDHCP = false;
    interfaces = {
      # normal computer
      enp8s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;

      # pi
      eth0.useDHCP = true;
    };
    nameservers = [ "1.1.1.1" ];
  };
  environment.etc."wpa_supplicant.conf".source = config.age.secrets.wpa.path;
}

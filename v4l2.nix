{ pkgs, config, ... }:

{
  boot.kernelModules = [ "v4l2loopback" ];
  # make modules available to modprobe
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
}

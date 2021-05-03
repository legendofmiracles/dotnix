# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
      fsType = "btrfs";
      options = [ "subvol=nixos" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd:9" "noatime" ];
    };

  fileSystems."/games" =
    {
      device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
      fsType = "btrfs";
      options = [ "subvol=steam" "compress=zstd" "noatime" "mode=777" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/A5AB-E355";
      fsType = "vfat";
    };

  swapDevices = [ ];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}

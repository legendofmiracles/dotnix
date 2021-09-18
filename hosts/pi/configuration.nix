{ config, pkgs, lib, ... }: {
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  # If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  # On a Raspberry Pi 4 with 4 GB, you should either disable this parameter or increase to at least 64M if you want the USB ports to work.
  boot.kernelParams = [ "cma=32M" ];

  # File systems configuration for using the installer's partition layout
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  # Or disable the firewall altogether.
  networking.firewall.enable = false;
  # networking.wireless.enable = true;
  networking.interfaces.eth0.useDHCP = true;

  networking.hostName = "pi";

  hardware.enableRedistributableFirmware = true;

  # !!! Adding a swap file is optional, but strongly recommended!
  swapDevices = [{
    device = "/swapfile";
    size = 1024;
  }];

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "builder";
      systems = [ "x86_64-linux" "aarch64-linux" ];
      maxJobs = 12;
      speedFactor = 10;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    }
  ];

  programs.ssh.extraConfig = ''
    Host builder
      HostName 192.168.1.21
      Port 22
      User nix-build-user
      IdentitiesOnly yes
      IdentityFile /home/nix/.ssh/pi
  '';
}

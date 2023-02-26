{ config, pkgs, lib, ... }: {
  boot = {
    loader = {
      raspberryPi = {
        enable = true;
        version = 4;
      };
      grub.enable = false;
    };
    kernelPackages = pkgs.linuxPackages_rpi4;
  };

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

  # connected by lan
  #networking.wireless.enable = true;

  networking.interfaces.eth0 = {
    useDHCP = true;
    ipv4.addresses = [ { address = "192.168.10.42"; prefixLength = 24; } ];
  };

  networking.hostName = "pikb";

  hardware.enableRedistributableFirmware = true;

  swapDevices = [{
    device = "/swapfile";
    size = 8192;
  }];

  nix.distributedBuilds = true;
  nix.buildMachines = [{
    hostName = "pain";
    sshKey = "/home/nix/.ssh/pi";
    sshUser = "nix-build-user";
    systems = [ "x86_64-linux" "aarch64-linux" ];
    maxJobs = 12;
    speedFactor = 10;
    supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  }];

  # faster rebuilding
  documentation = {
    enable = false;
    doc.enable = false;
    man.enable = false;
    dev.enable = false;
  };

  services.photoprism = {
    enable = true;
    originalsPath = "/var/lib/private/photoprism/photos";
    importPath = "/var/lib/private/photoprism/import";
    address = "192.168.10.109";
    # change later
    passwordFile = "/var/lib/ipcpassasf";
    settings = {
      PHOTOPRISM_SPONSOR = "true";
    };
  };

  # photoprism needs this
  users = {
    users.photoprism = {
      home = "/var/lib/photoprism";
      isSystemUser = true;
      group = "photoprism";
      description = "photoprism service user";
    };
    groups.photoprism = { };
  };

}

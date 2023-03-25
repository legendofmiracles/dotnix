{ config, pkgs, lib, ... }: {
  boot = {
    loader = {
      /*raspberryPi = {
        enable = true;
        version = 4;
      };*/
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };/*
    kernelPackages = pkgs.linuxPackages_rpi4;*/
    initrd.availableKernelModules = [ "xhci_pci" "usbhid" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };
    "/photos" = {
      device = "/dev/disk/by-uuid/03bb813c-cb16-48da-8072-421b773ca117";
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

  # normally connected by lan
  #networking.wireless.enable = true;

  networking.networkmanager.enable = true;

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

  nix.distributedBuilds = false; #TEMPORARILY DISABLED
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
    originalsPath = "/photos/photoprism/photos";
    importPath = "/photos/photoprism/import";
    address = "0.0.0.0";
    # change later
    passwordFile = "/var/lib/passwd";
    settings = {
      PHOTOPRISM_SPONSOR = "true";
    };
  };

  # photoprism needs this
  users = {
    users.photoprism = {
      home = "/photos/photoprism";
      isSystemUser = true;
      #isNormalUser = true;
      group = "photoprism";
      description = "photoprism service user";
    };
    groups.photoprism = { };
    users.syncthing = {
      extraGroups = [ "photoprism" ];
    };
  };

  systemd.timers."update-photos" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 03:00:00";
        Unit = "update-photos.service";
      };
  };

  systemd.services.photoprism = {
    wantedBy = lib.mkForce [];

    serviceConfig = {
      DynamicUser = lib.mkForce false;
      PrivateDevices = lib.mkForce false;
    };
  };

  systemd.services."update-photos" = {
    script = ''
      set -eu
      path=/photos/photoprism/import/*
      chown photoprism:photoprism $path || true
      chmod 770 $path || true
      ${pkgs.curl}/bin/curl 'http://127.0.0.1:2342/api/v1/import/' --fail-with-body -X POST -H "X-Session-ID: $(cat /var/lib/passwd-session-id)"  --data-raw '{"path":"/","move":true}'
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    onFailure = [ "notify-email@%n.service" ];
  };

  systemd.paths = {
    update-photos = {
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        DirectoryNotEmpty = "/photos/photoprism/import";
      };
    };
    
    photoprism = {
      wantedBy = [ "multi-user.target" ];
      pathConfig = {
        PathExists = "/photos/photoprism/photos";
      };
    };
  };

  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
  };

  services.nginx = {
    enable = false;
    virtualHosts."photoprism-redirect.com" = {
      root = "/photos/photoprism/serve";
      listenAddresses = [ "0.0.0.0" ];
    };
  };
}

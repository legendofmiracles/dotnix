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

  #disabledModules = [ "services/web-apps/photoprism.nix" ];

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

  /*systemd.timers."update-photos" = {
    wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*-*-* 04:00:00";
        Unit = "update-photos.service";
      };
  };*/

  systemd.services."update-photos" = {
    script = ''
      set -eu
      path=/photos/photoprism/import/*
      chown photoprism:photoprism $path || true
      chmod 770 $path || true
      ./${pkgs.writers.writePython3 "start-import" {
        flakeIgnore = [ "E501" ];
        libraries = [
          (pkgs.python3Packages.buildPythonPackage rec {
            pname = "photoprism_client";
            version = "unstable-22-10-2022";
            src = pkgs.fetchFromGitHub {
              owner = "mvlnetdev";
              repo = "photoprism_client";
              rev = "d7aed5f210647319fe83c15287198c8ba82a309e";
              sha256 = "sha256-PlDOzzxwqFVSl5nSQ97En+QJFI7dxmvGbonzgErAhEk=";
            };
            doCheck = false;
            propagatedBuildInputs = [
              # Specify dependencies
              pkgs.python3Packages.requests
            ];
          })
        ];
      }
      ''
        from photoprism.Session import Session
        from photoprism.Photo import Photo

        pp_session = Session("admin", open("/var/lib/passwd", "r").read(), "127.0.0.1:2432")
        pp_session.create()
        p = Photo(pp_session)
        p.start_import(path="import", move=True)
      ''
      }
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    onFailure = [ "notify-email@%n.service" ];
  };

  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
  };

  services.nginx = {
    enable = true;
    virtualHosts."photoprism-redirect.com" = {
      root = "/photos/photoprism/serve";
      listenAddresses = [ "0.0.0.0" ];
    };
  };
}

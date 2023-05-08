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
    settings.PermitRootLogin = "yes";
  };

  networking.firewall.enable = false;

  # normally connected by lan
  networking.wireless.enable = false;

  networking.networkmanager.enable = false;

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
    passwordFile = config.age.secrets.photoprism.path;
    settings = {
      PHOTOPRISM_SPONSOR = "true";
    };
  };

  users = {
    # complete git server only with configuring one user
    users.git = {
      packages = with pkgs; [ git ];
      home = "/srv/git";
      #createHome = true;
      isSystemUser = true;
      group = "git";
      description = "git ssh user";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIONNQcvhcUySNuuRKroWNAgSdcfy7aqO3UsezT/C/XAQ legendofmiracles@protonmail.com"
      ];
      # needed to not have the account be 'disabled'
      shell = "${pkgs.git}/bin/git-shell";
    };
    groups.git = { };
    # photoprism needs this
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
      set -eux
      path=/photos/photoprism/import/*
      session_id=$(${pkgs.curl}/bin/curl 'http://127.0.0.1:2342/api/v1/session' --fail-with-body -X POST --data-raw "{\"username\":\"admin\", \"password\":\"$(cat /var/lib/passwd-session-id)\"}" | ${pkgs.jq}/bin/jq -r .id)
      chown photoprism:photoprism $path || true
      chmod 770 $path || true
      ${pkgs.curl}/bin/curl 'http://127.0.0.1:2342/api/v1/import/' --fail-with-body -X POST -H "X-Session-ID: $session_id"  --data-raw '{"path":"/","move":true}'
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

  services.archisteamfarm = {
    enable = true;
    bots = {
      lom = {
        username = "LegendOfMiracles";
        passwordFile = config.age.secrets.steam.path;
      };
    };

    settings = {
      SteamOwnerID = "76561198815866999";
      Statistics = false;
      AutoSteamSaleEvent = true;
    };

    ipcPasswordFile = config.age.secrets.photoprism.path;
    ipcSettings = {
      Kestrel = {
          Endpoints = {
            HTTP = {
              Url = "http://*:1242";
            };
          };
        };
    };
  };

  system.stateVersion = "23.05";
}

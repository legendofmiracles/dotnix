{ config, pkgs, lib, ... }: {
  boot = {
    loader = {
      /* raspberryPi = {
           enable = true;
           version = 4;
         };
      */
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    }; # kernelPackages = pkgs.linuxPackages_rpi4;
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
    ipv4.addresses = [{
      address = "10.0.0.42";
      prefixLength = 24;
    }];
  };

  networking.hostName = "pikb";

  hardware.enableRedistributableFirmware = true;

  swapDevices = [{
    device = "/swapfile";
    size = 8192;
  }];

  nix.distributedBuilds = false; # TEMPORARILY DISABLED
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
    settings = { PHOTOPRISM_SPONSOR = "true"; };
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
    users.syncthing = { extraGroups = [ "photoprism" ]; };
  };

  systemd.timers."update-photos" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Unit = "update-photos.service";
    };
  };

  systemd.services.photoprism = {
    wantedBy = lib.mkForce [ ];

    serviceConfig = {
      DynamicUser = lib.mkForce false;
      PrivateDevices = lib.mkForce false;
    };
  };

  systemd.services."update-photos" = {
    script = ''
      set -eux
      path=/photos/photoprism/import/*
      session_id=$(${pkgs.curl}/bin/curl 'http://127.0.0.1:2342/api/v1/session' --fail-with-body -X POST --data-raw "{\"username\":\"admin\", \"password\":\"$(cat ${config.age.secrets.photoprism.path})\"}" | ${pkgs.jq}/bin/jq -r .id)
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
      pathConfig = { DirectoryNotEmpty = "/photos/photoprism/import"; };
    };

    photoprism = {
      wantedBy = [ "multi-user.target" ];
      pathConfig = { PathExists = "/photos/photoprism/photos"; };
    };
  };

  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
    extraOptions = {
      gui = {
        user = "";
        password = "";
      };
    };
  };

  services.archisteamfarm = {
    enable = true;
    bots = {
      lom = {
        username = "LegendOfMiracles";
        passwordFile = config.age.secrets.steam.path;
      };
      jonas = {
        username = "KillingLegends";
        passwordFile = config.age.secrets.steam-jonas.path;
      };
    };

    settings = {
      SteamOwnerID = "76561198815866999";
      Statistics = false;
      AutoSteamSaleEvent = true;
    };

    # ignore that it's for a diffrent service ;)
    ipcPasswordFile = config.age.secrets.photoprism.path;
    ipcSettings = {
      Kestrel = { Endpoints = { HTTP = { Url = "http://*:1242"; }; }; };
    };
  };

  system.stateVersion = "23.05";

  /* virtualisation.oci-containers.containers = {
           MAPBOX_API_KEY = "this string doesn't even matter";
         };
       };
     };
  */

  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    initialScript = pkgs.writeText "init-db.sql" ''
      CREATE DATABASE firefly;
      CREATE USER 'firefly'@'localhost' IDENTIFIED BY 'PASSWORD'; 
      GRANT ALL PRIVILEGES ON firefly.* TO 'firefly'@'localhost';
      FLUSH PRIVILEGES;
    '';
  };

  systemd.timers."cron-firefly" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Unit = "cron-firefly.service";
    };
  };
  systemd.services."cron-firefly" = {
    script = ''
      set -eux
      cd /var/www/html/firefly-iii/
      ${pkgs.php82}/bin/php artisan firefly-iii:cron
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    onFailure = [ "notify-email@%n.service" ];
  };

  services.nginx = {
    enable = true;
    virtualHosts."firefly" = {
      forceSSL = false;

      root = "/var/www/html/firefly-iii/public";
      locations."/" = { tryFiles = "$uri /index.php$is_args$args"; };

      extraConfig = ''
        index index.html index.htm index.php;
      '';

      locations."~ .php$".extraConfig = ''
        fastcgi_pass  unix:${config.services.phpfpm.pools.firefly-importer.socket};
        fastcgi_index index.php;
        fastcgi_read_timeout 240;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include ${pkgs.nginx}/conf/fastcgi_params;
        fastcgi_split_path_info ^(.+.php)(/.+)$;
      '';
    };

    virtualHosts."importer" = {
      root = "/var/www/html/firefly-importer/public";
      listen = [{
        port = 8080;
        addr = "0.0.0.0";
      }];

      locations."/" = {
        tryFiles = "$uri /index.php$is_args$args";
        extraConfig = ''
          proxy_buffer_size          128k;
          proxy_buffers              4 256k;
          proxy_busy_buffers_size    256k;
          autoindex on;
          sendfile off;
        '';
      };

      locations."~ .php$".extraConfig = ''
        fastcgi_pass  unix:${config.services.phpfpm.pools.firefly-importer.socket};
        fastcgi_index index.php;
        fastcgi_read_timeout 240;
        fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
        include ${pkgs.nginx}/conf/fastcgi_params;
        fastcgi_split_path_info ^(.+.php)(/.+)$;
        fastcgi_buffers 16 32k;
        fastcgi_buffer_size 64k;
        fastcgi_busy_buffers_size 64k;
      '';
    };
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "legendofmiracles@protonmail.com";

  services.phpfpm = {
    phpPackage = pkgs.php82;
    pools.firefly = {
      user = "nginx";
      settings = {
        pm = "dynamic";
        "listen.owner" = config.services.nginx.user;
        "pm.max_children" = 5;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 3;
        "pm.max_requests" = 500;
      };
    };
    pools.firefly-importer = {
      user = "nginx";
      phpPackage =
        pkgs.php82.withExtensions ({ enabled, all }: enabled ++ [ all.bcmath ]);
      settings = {
        pm = "dynamic";
        "listen.owner" = config.services.nginx.user;
        "pm.max_children" = 5;
        "pm.start_servers" = 2;
        "pm.min_spare_servers" = 1;
        "pm.max_spare_servers" = 3;
        "pm.max_requests" = 500;
      };
    };
  };

  services.tandoor-recipes = {
    enable = true;
    port = 1234;
    address = "0.0.0.0";
  };

  services.paperless = {
    enable = false;
    passwordFile = config.age.secrets.photoprism.path;
    address = "0.0.0.0";
  };

  services.adguardhome = {
    enable = true;
  };

  virtualisation.oci-containers.containers = {
    /*
    watchtower = {
      image = "containrrr/watchtower";
      cmd = [ "--cleanup --interval 3600" ];
    };*/
    # doesn't run on arm
    /*archiver = {
      image = "atdr.meo.ws/archiveteam/urls-grab";
      cmd = [ "--concurrent 1 lom" ];
    };*/
  };
}

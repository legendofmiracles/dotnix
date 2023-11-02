{ config, pkgs, lib, ... }: {
  boot = {
    loader = {
      grub.enable = false;
      generic-extlinux-compatible.enable = true;
    };
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
  };

  networking.hostName = "pikb";

  hardware.enableRedistributableFirmware = true;

  swapDevices = [{
    device = "/swapfile";
    size = 12192;
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

  environment.systemPackages = with pkgs; [ tmux iftop ];

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

  systemd.services.photoprism = {
    wantedBy = lib.mkForce [ ];

    serviceConfig = {
      DynamicUser = lib.mkForce false;
      PrivateDevices = lib.mkForce false;
    };
  };

  systemd.timers."update-photos" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 03:00:00";
      Unit = "update-photos.service";
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
    settings = {
      gui = {
        user = "";
        password = "";
      };
    };
    overrideFolders = false;
    overrideDevices = false;
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

  services.tandoor-recipes = {
    enable = false;
    port = 1234;
    address = "0.0.0.0";
  };

  services.paperless = {
    enable = false;
    passwordFile = config.age.secrets.photoprism.path;
    address = "0.0.0.0";
  };

  # services.adguardhome = { enable = true; };

  virtualisation.oci-containers.containers = {
    firefly = {
      image = "fireflyiii/core:latest";
      volumes = [ "/var/lib/firefly:/var/www/html/storage/upload" ];
      environment = {
        DB_HOST = "127.0.0.1";
        DB_PORT = "3306";
        DB_CONNECTION = "mysql";
        DB_DATABASE = "firefly";
        DB_USERNAME = "firefly";
        DB_PASSWORD = "PASSWORD";
      };
      environmentFiles = [ config.age.secrets.services-env.path ];
      extraOptions = [ "--net=host" "-m=5g"];
    };
    firefly-bot = {
      image = "cyxou/firefly-iii-telegram-bot:latest";
      volumes = [ "/var/lib/firefly-bot/:/home/node/app/sessions" ];
      environmentFiles = [ config.age.secrets.services-env.path ];
      dependsOn = [ "firefly" ];
      extraOptions = [ "--arch=arm" "--net=host" ];
    };
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
      ${pkgs.podman}/bin/podman exec --user=www-data firefly /usr/local/bin/php /var/www/html/artisan firefly-iii:cron
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
    onFailure = [ "notify-email@%n.service" ];
  };


  /*services.firefox-syncserver = {
    enable = true;
    singleNode = {
      enable = true;
      enableNginx = true;
      hostname = "10.0.0.42";
    };
    secrets = config.age.secrets.services-env.path;
  };*/

  services.nginx.enable = true;

  services.nginx.virtualHosts."lomom.party" = {
    forceSSL = true;
    enableACME = true;
    root = "/var/www/html";
  };

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "legendofmiracles@protonmail.com";

  networking.wireguard = {
    enable = true;
    interfaces."wg0" = {
      privateKeyFile = "/var/keys/wg0-priv-key";
      generatePrivateKeyFile = true;
      ips = [ "10.0.0.1/24" ];
      listenPort = 51820;
      peers = [ 
        {
          # ipad
          allowedIPs = [ "10.0.0.2/32" ];
          publicKey = "wK0pR/h5duC9JFqihJ+7u5GfeP8NfU0SS/eKUvAFKVw=";
        }
        {

          #phone
          allowedIPs = [ "10.0.0.3/32" ];
          publicKey = "SrIYdkbmwB7CmkdWCCOuKSBMK1LPO0JSByyzBXnKqwQ=";
        }
      ];
    };
  };

  networking.nat.enable = true;
  networking.nat.externalInterface = "eth0";
  networking.nat.internalInterfaces = [ "wg0" ];

  systemd.timers."backup-photoprism" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "*-*-* 4:00:00";
      Unit = "update-dns.service";
      Persistent = true;
    };
  };
  systemd.services."backup-photoprism" = {
    script = ''
    set -ex

    export BORG_PASSPHRASE=$(cat ${config.age.secrets.backup-encryption-pass.path})
    export BORG_REMOTE_PATH="/mnt/Hoarder/onyx/borg-linux64" 
    export BORG_RSH="ssh -i ${config.age.secrets.backup-ssh-key.path}"  

    borg create --progress --stats --verbose ssh://lom@jita.cubox.dev:6969/mnt/Hoarder/lom/photos::$(date -I) /photos/photoprism/photos

    borg prune —verbose —stats —keep-last=10 ssh://lom@jita.cubox.dev:6969/mnt/Hoarder/lom/photos

    borg compact —progress ssh://lom@jita.cubox.dev:6969/mnt/Hoarder/lom/photos
    '';
      path = [ pkgs.borgbackup ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      onFailure = [ "notify-email@%n.service" ];
  };

  systemd.timers."update-dns" = {
      wantedBy = [ "timers.target" ];
      timerConfig = {
        OnCalendar = "*:0/15";
        Unit = "update-dns.service";
        Persistent = true;
      };
    };
  systemd.services."update-dns" = {
      script = ''
        set -x
        source "${config.age.secrets.services-env.path}"
        #grab wan ip from canhazip and set variable to output
        output=$(curl http://canhazip.com)

        current=$(dig +short lomom.party)

        if [[ "$current" == "$output" ]]; then
          echo Same IP
          exit 0
        fi

        #display wan ip for troubleshooting
        echo "$output";

        #update dns ip of sub.domain.com via porkbun api
        curl \
        --header "Content-type: application/json" \
        --request POST \
        --data '{"secretapikey":"'$SECRET_KEY'","apikey":"'$API_KEY'","content":"'$output'", "type":"A"}' \
        https://porkbun.com/api/json/v3/dns/edit/lomom.party/346829051
      '';
      path = [ pkgs.curl pkgs.dig ];
      serviceConfig = {
        Type = "oneshot";
        User = "root";
      };
      onFailure = [ "notify-email@%n.service" ];
    };
}

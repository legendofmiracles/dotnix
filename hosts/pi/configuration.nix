{ config, pkgs, lib, ... }: {
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;

  # !!! Needed for the virtual console to work on the RPi 3, as the default of 16M doesn't seem to be enough.
  # If X.org behaves weirdly (I only saw the cursor) then try increasing this to 256M.
  # On a Raspberry Pi 4 with 4 GB, you should either disable this parameter or increase to at least 64M if you want the USB ports to work.
  boot = {
    kernelParams = [ "cma=32M" ];
    # workaround for issues with the bootloader
    kernelPackages = pkgs.linuxPackages_5_4;
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
    ipv4.addresses = [ { address = "192.168.1.69"; prefixLength = 24; } ];
  };

  networking.hostName = "pi";

  hardware.enableRedistributableFirmware = true;

  swapDevices = [{
    device = "/swapfile";
    size = 2048;
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

  /* programs.ssh.extraConfig = ''
       Host builder
         HostName 192.168.1.16
         Port 22
         User nix-build-user
         IdentitiesOnly yes
         IdentityFile /home/nix/.ssh/pi
     '';
  */

  # complete git server only with configuring one user
  users = {
    users.git = {
      packages = with pkgs; [ git ];
      home = "/srv/git";
      createHome = true;
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
  };

  # faster rebuilding
  documentation = {
    enable = false;
    doc.enable = false;
    man.enable = false;
    dev.enable = false;
  };

  services.discord.wednesday = {
    desc = "It's wednesday my dudes!";
    server = "Best Server";
    channel = "main";
    content = "<:wednesday:806483241045196841> It's Wednesday my dudes!";
    when = "Wed *-*-* 00:00:00";
  };
  /*services.discord.update = {
    desc = "update timer for creepylove";
    server = "lolsu-keks";
    channel = "general";
    content = "<@336863335431798785> update!!!11";
    when = "*-*-* 00:00:00";
  };*/
  services.discord.macky-bday = {
    desc = "wishes for a friend";
    server = "Best Server";
    channel = "main";
    content = "<@568326274653880341> happy birthday! :partying_face:";
    when = "*-11-11 00:00:00";
  };
  /* services.discord.cat-facts = {
       desc = "almost annoying";
       server = "Best Server";
       channel = "meta";
       content = "<@&905815924601401384> Random cat fact! $(${pkgs.curl}/bin/curl https://catfact.ninja/fact | ${pkgs.jq}/bin/jq -r .fact)";
       when = "*-*-* *:00:00";
     };
  */

  services.archisteamfarm = {
    enable = true;
    bots = {
      lom = {
        username = "LegendOfMiracles";
        passwordFile = "/run/agenix/steam";
      };
      hlgr360 = {
        enabled = false;
        passwordFile = "/run/agenix/steam-2";
      };
      ktya360 = {
        passwordFile = "/run/agenix/steam-3";
        settings = {
          SteamParentalCode = "3952";
        };
        enabled = false;
      };
    };
    settings = {
      SteamOwnerID = "76561198815866999";
      #Debug = true;
      IPCPassword = "test";
    };
    ipcSettings = {
      Kestrel = {
          Endpoints = {
            HTTP = {
              Url = "http://192.168.1.*:1242";
            };
          };
        };
    };
  };

  services.adguardhome = {
    enable = true;
    settings = {
      dns = {
        bind_host = "192.168.1.69";
        bootstrap_dns = "9.9.9.9";
        upstream_dns = [ "9.9.9.9" "1.1.1.1" ];
      };
    };
  };
}

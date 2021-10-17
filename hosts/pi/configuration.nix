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
  # networking.wireless.enable = true;
  networking.interfaces.eth0.useDHCP = true;

  networking.hostName = "pi";

  hardware.enableRedistributableFirmware = true;

  swapDevices = [{
    device = "/swapfile";
    size = 1024;
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

  services.firefox.syncserver = {
    #enable = true;
  };

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
  services.discord.update = {
    desc = "update timer for creepylove";
    server = "lolsu-keks";
    channel = "general";
    content = "<@336863335431798785> update!!!11";
    when = "Fri *-*-* 00:00:00";
  };
}

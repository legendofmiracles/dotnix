# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  # documentation.enable = false;

  boot = {
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_5_11;
    kernelModules = [ "snd_hda_intel" ];
    extraModprobeConfig = ''
      options snd-hda-intel model=Intel Generic
      options snd-hda-intel dmic_detect=0
      options probe_mask=1
    '';
    # blacklistedKernelModules = [ "i2c_nvidia_gpu" ];
    kernelParams = [ "rcutree.rcu_idle_gp_delay=1" ];
  };

  # evaluates
  age.secrets.wifi.file = ../../secrets/wifi.json.age;

  networking = {
    hostName = "pain";
    wireless = {
      enable = true;
      # doesn't eval
      networks = lib.listToAttrs (lib.lists.forEach (builtins.fromJSON (builtins.readFile config.age.secrets.wifi.path)) (x:
        {
          name = x.name;
          value = { psk = x.psk; };
        }
      )
      );
    };
    useDHCP = false;
    interfaces = {
      enp8s0.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };
    nameservers = [ "1.1.1.1" ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  hardware.cpu.intel.updateMicrocode = true;

  # hardware.enableAllFirmware = true;
  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "f19:ö,f20:ü,f21:ä,a:b";

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.steam.enable = true;

  programs.dconf.enable = true;

  services.snapper.configs =
    {
      home = {
        subvolume = "/home";
        extraConfig = ''
          ALLOW_USERS="nix"
          TIMELINE_CREATE="yes"
          TIMELINE_CLEANUP="yes"
        '';
      };
    };

  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "dialout" "libvirtd" ];
    shell = pkgs.fish;
  };

  # virtualisation.libvirtd.enable = true;

  environment.sessionVariables = {
    "NIXOS_CONFIG" = "/home/nix/dotnix";
  };

  programs.fish = {
    enable = true;
    vendor.completions.enable = true;
  };

  environment.variables = {
    fish_greeting = "";
  };

  environment.systemPackages = with pkgs; [
    cascadia-code
    pciutils
    virt-manager
    man-pages
    # agenix.defaultPackage.x86_64-linux
  ];

  hardware.keyboard.zsa.enable = true;

  nix = {
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
    trustedUsers = [ "root" "nix" ];
    gc.automatic = true;
    gc.options = "--delete-older-than 3d";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  powerManagement.cpuFreqGovernor = "performance";

  system.stateVersion = "21.05";
}

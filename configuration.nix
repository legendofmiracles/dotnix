# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot = {
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    # kernelPackages = pkgs.linuxPackages_5_4;
    kernelModules = [ "snd_hda_intel" ];
    extraModprobeConfig = ''
      options snd-hda-intel model=Intel Generic
      options snd-hda-intel dmic_detect=0
      options probe_mask=1
    '';
    # kernelParams = [ "rcutree.rcu_idle_gp_delay=1" ];
  };

  networking = {
    hostName = "pain";
    wireless.enable = true;
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
  # services.xserver.xkbOptions = "eurosign:e";

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
        '';
      };
    };

  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ];
    shell = pkgs.fish;
  };

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
    man-pages
    # agenix.defaultPackage.x86_64-linux
  ];

  nix = {
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
  };

  nix.trustedUsers = [ "root" "nix" ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  powerManagement.cpuFreqGovernor = "performance";

  system.stateVersion = "21.05";
}

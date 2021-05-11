# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, modulesPath, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # documentation.enable = false;

  boot = {
    initrd = {
      availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_5_11;
    kernelModules = [ "snd_hda_intel" "kvm-intel" ];
    extraModprobeConfig = ''
      options snd-hda-intel model=Intel Generic
      options snd-hda-intel dmic_detect=0
      options probe_mask=1
    '';
    # blacklistedKernelModules = [ "i2c_nvidia_gpu" ];
    kernelParams = [ "rcutree.rcu_idle_gp_delay=1" ];
  };

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
      fsType = "btrfs";
      options = [ "subvol=nixos" "compress=zstd" "noatime" ];
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd:9" "noatime" ];
    };

  fileSystems."/games" =
    {
      device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
      fsType = "btrfs";
      options = [ "subvol=steam" "compress=zstd" "noatime" "mode=777" ];
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/A5AB-E355";
      fsType = "vfat";
    };

  networking.hostName = "pain";

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

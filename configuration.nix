# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./secrets/pain.nix
      ./udev.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot = {
    cleanTmpDir = true;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_5_11;
    kernelModules = [ "v4l2loopback" "snd_hda_intel" ];
    extraModprobeConfig = ''
      options snd-hda-intel model=Intel Generic
      options snd-hda-intel dmic_detect=0
      options probe_mask=1
    '';
  };

  networking.hostName = "pain";
  networking.wireless.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  networking.useDHCP = false;
  networking.interfaces.enp8s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.nameservers = [ "1.1.1.1" ];

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  hardware.cpu.intel.updateMicrocode = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  # services.xserver.xkbVariant = "colemak";

  services.xserver.displayManager.startx.enable = true;


  hardware.nvidia.prime = {
    offload.enable = true;

    intelBusId = "PCI:0:2:0";

    nvidiaBusId = "PCI:1:0:0";

  };

  hardware.enableAllFirmware = true;
  hardware.opengl.driSupport32Bit = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  programs.steam.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;
  services.xserver.config = ''
    Section "InputClass"
          Identifier "mouse accel"
          Driver "libinput"
          MatchIsPointer "on"
          Option "AccelProfile" "flat"
                Option "AccelSpeed" "0"
              EndSection
  '';

  services.snapper.configs =
    {
      home = {
        subvolume = "/home";
        extraConfig = ''
          ALLOW_USERS="nix"
        '';
      };
    };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" ];
    shell = pkgs.fish;
  };

  environment.sessionVariables = {
    "NIXOS_CONFIG" = "/home/nix/dotnix/configuration.nix";
  };

  programs.fish.enable = true;

  programs.fish.vendor.completions.enable = true;

  environment.variables = {
    fish_greeting = "";
  };

  environment.systemPackages = with pkgs; [
    cascadia-code
    wget
    vim
    pciutils
    libnotify
    zip
    man-pages
    nvidia-offload
    agenix.defaultPackage.x86_64-linux
  ];

  nix = {
    package = pkgs.nixFlakes;
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

  powerManagement.cpuFreqGovernor = "powersave";

  system.stateVersion = "21.05";
}


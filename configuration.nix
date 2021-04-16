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
      ./secrets.nix
      ./udev.nix
    ];

  # enables unfree (please don't kill me stallman)
  nixpkgs.config.allowUnfree = true;

  # Use the systemd-boot EFI boot loader.
  # boot.kernelPackages = pkgs.linuxPackages_5_11;
  boot.cleanTmpDir = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelModules = [ "v4l2loopback" "snd_hda_intel" ];
  boot.extraModprobeConfig = ''
    options snd-hda-intel model=Intel Generic
    options snd-hda-intel dmic_detect=0
    options probe_mask=1
  '';
  # boot.blacklistedKernelModules = [ "i915" ];
  networking.hostName = "pain"; # Define your hostname.
  networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
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
  # services.xserver.videoDrivers = [ "nvidia" ];
  # hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;
  # services.xserver.xkbVariant = "colemak";
  # hardware.nvidiaOptimus.disable = true;

  services.xserver.displayManager.startx.enable = true;


  hardware.nvidia.prime = {
    offload.enable = false;

    intelBusId = "PCI:00:02:0";

    nvidiaBusId = "PCI:01:00:0";

  };

  #hardware.enableAllFirmware = true;
  #hardware.opengl.enable = true;
  hardware.opengl.driSupport32Bit = true;
  # hardware.nvidia.nvidiaPersistenced = true;
  #hardware.opengl.driSupport = true;

  # Configure keymap in X11
  services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

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

  programs.neovim.defaultEditor = true;

  environment.sessionVariables = {
    "NIXOS_CONFIG" = "/home/nix/dotnix/configuration.nix";
  };

  #programs.neovim.defaultEditor = true;

  programs.fish.enable = true;

  environment.variables = {
    fish_greeting = "";
  };

  #nixpkgs.overlays = [
  #  (import (fetchTarball https://github.com/nix-community/fenix/archive/main.tar.gz))
  #];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    cascadia-code
    wget
    vim
    pciutils
    libnotify
    zip
    man-pages
    # tor-browser-bundle-bin
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
  services.openssh.allowSFTP = true;

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  powerManagement.cpuFreqGovernor = "powersave";

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}


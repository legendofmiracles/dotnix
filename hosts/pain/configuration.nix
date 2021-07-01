{ config, pkgs, lib, modulesPath, inputs, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    #(modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    #(modulesPath + "/installer/cd-dvd/channel.nix")
  ];

  # documentation.enable = false;

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
      kernelModules = [ ];
    };
    cleanTmpDir = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = [ "snd_hda_intel" "kvm-intel" ];
    extraModprobeConfig = ''
      options snd-hda-intel model=Intel Generic
      options snd-hda-intel dmic_detect=0
      options probe_mask=1
    '';
    # blacklistedKernelModules = [ "i915" ];
    # kernelParams = [ "rcutree.rcu_idle_gp_delay=1" ];
    kernel.sysctl = { "dev.i915.perf_stream_paranoid" = 0; };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
    fsType = "btrfs";
    options = [ "subvol=nixos" "compress=zstd" "noatime" ];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd:11" "noatime" ];
  };

  fileSystems."/games" = {
    device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
    fsType = "btrfs";
    options = [ "subvol=steam" "compress=zstd" "noatime" "mode=777" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/A5AB-E355";
    fsType = "vfat";
  };

  networking.hostName = "pain";
  networking.interfaces = {
    enp8s0.useDHCP = true;
    wlp0s20f3.useDHCP = true;
  };

  services.flatpak.enable = true;
  xdg.portal.enable = true;

  hardware.cpu.intel.updateMicrocode = true;

  # hardware.enableAllFirmware = true;
  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "f19:ö,f20:ü,f21:ä,a:b";

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound.
  sound.enable = true;

  services.pipewire = {
    enable = true;
    alsa = {
      enable = true;
      support32Bit = true;
    };

    pulse.enable = true;

    lowLatency = {
      enable = true;
      # defaults (no need to be set unless modified)
      quantum = 32;
      rate = 48000;
    };
  };

  # make pipewire realtime-capable
  security.rtkit.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      chromium = {
        executable = "${lib.getBin pkgs.ungoogled-chromium}/bin/chromium";
        profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
      };
    };
  };

  # programs.gamemode.enable = true;

  programs.dconf.enable = true;

  services.snapper.configs = {
    home = {
      subvolume = "/home";
      extraConfig = ''
        ALLOW_USERS="nix"
        TIMELINE_CREATE="yes"
        TIMELINE_CLEANUP="yes"
      '';
    };
  };

  programs.noisetorch.enable = true;

  # services.fwupd.enable = true;

  # virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    pciutils
    virt-manager
    (steam.override { extraPkgs = pkgs: [ ibus wine winetricks ]; extraProfile = ''unset VK_ICD_FILENAMES''; })
  ];

  hardware.keyboard.zsa.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Or disable the firewall altogether.
  networking.firewall.enable = false;

  powerManagement.cpuFreqGovernor = "performance";

  system.stateVersion = "21.05";
}

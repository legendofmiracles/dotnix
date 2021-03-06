{ config, pkgs, lib, modulesPath, inputs, ... }:

{
  # BINFMT support
  #qemu-user.aarch64 = true;

  boot = {
    initrd = {
      availableKernelModules =
        [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
    };
    cleanTmpDir = true;
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    kernelPackages = pkgs.linuxPackages_xanmod;
    kernelModules = [ "snd_hda_intel" "kvm-intel" ];
    extraModprobeConfig = ''
      options snd-hda-intel model=Intel Generic
      options snd-hda-intel dmic_detect=0
      options probe_mask=1
    '';
    #blacklistedKernelModules = [ "i915" ];
    #kernelParams = [ "rcutree.rcu_idle_gp_delay=1" ];
    kernel.sysctl = { "dev.i915.perf_stream_paranoid" = 0; };
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
      fsType = "btrfs";
      options = [ "subvol=nixos" "compress=zstd" "noatime" ];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
      fsType = "btrfs";
      options = [ "subvol=home" "compress=zstd:11" "noatime" ];
    };
    "/games" = {
      device = "/dev/disk/by-uuid/929d345e-81a3-480c-9029-2aa5414fc8cf";
      fsType = "btrfs";
      options = [ "subvol=steam" "compress=zstd" "noatime" "mode=777" ];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/A5AB-E355";
      fsType = "vfat";
    };
  };

  #services.ratbagd.enable = false;

  networking.hostName = "pain";
  networking.interfaces = {
    enp8s0 = {
      useDHCP = true;
      wakeOnLan = { enable = true; };
      ipv4.addresses = [ { address = "192.168.1.42"; prefixLength = 24; } ];
    };
    #wlp0s20f3.useDHCP = true;
  };

  hardware.cpu.intel.updateMicrocode = true;

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
    wireplumber.enable = true;

    media-session.enable = false;
  };


  hardware.pulseaudio.enable = false;

  # make pipewire realtime-capable
  security.rtkit.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  programs.weylus = {
    enable = true;
    users = [ "nix" ];
  };

  programs.firejail = {
    enable = true;
    wrappedBinaries = {
      chromium = {
        executable = "${lib.getBin pkgs.chromium}/bin/chromium";
        profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
      };
    };
  };

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

  services.logind.lidSwitch = "suspend";

  systemd.services.sleep = {
    description = "Lock the screen";
    before = [ "sleep.target" ];

    environment = { DISPLAY = ":0"; };

    serviceConfig = {
      User = "nix";
      Type = "forking";
      ExecStart = "${pkgs.writeShellScript "lock" ''
        C='0xe9e922'
        D='#ff00ffcc'
        T='#ee00eeee'
        B='#00000000'
        V='#bb00bbbb'
        W='#880000bb'

        ${
          lib.getBin pkgs.i3lock-color
        }/bin/i3lock-color --insidever-color=$C --ringver-color=$V --insidewrong-color=$C --ringwrong-color=$W --inside-color=$B --ring-color=$D --line-color=$B --separator-color=$D --verif-color=$T --wrong-color=$T --time-color=$T --date-color=$T --layout-color=$T --keyhl-color=$W  --bshl-color=$W  --screen 1  --blur 5  --clock --indicator --time-str="%H:%M:%S" --date-str="%A, %m %Y" --keylayout 2 --verif-text="Why should i even be checking this password? its wrong anyways." --wrong-text="Nice try ;)" --greeter-text="You want to use the computer? Good luck finding the password..." --greeter-color=$V
      ''}";
    };

    wantedBy = [ "sleep.target" ];
  };

  # enables wake on lan
  /* systemd.network.links."40-wol" = {
       enable = true;
       matchConfig = {
         MACAddress = "8c:47:be:15:a7:0f";
       };
       linkConfig = {
         NamePolicy = "kernel database onboard slot path";
         MACAddressPolicy = "persistent";
         WakeOnLan = "magic";
       };
     };
  */

  #services.fwupd.enable = true;

  #virtualisation.libvirtd.enable = true;

  environment.systemPackages = with pkgs; [
    pciutils
    #libimobiledevice
    #virt-manager
    libstrangle
    /* (steam.override {
         extraPkgs = pkgs: with pkgs; [ pango harfbuzz libthai ];
       })
    */
  ];

  #virtualisation.docker.enable = true;

  # enable if you want to do stuff with ios
  #services.usbmuxd.enable = true;

  /* programs.cowsay = {
       enable = true;
       cows.giraffe = ''
         $thoughts
          $thoughts
           $thoughts
              ^__^
              (oo)
              (__)
                \\ \\
                 \\ \\
                  \\ \\
                   \\ \\
                    \\ \\
                     \\ \\
                      \\ \\
                       \\ \\______
                        \\       )\\/\\/\\
                         ||----w |
                         ||     ||
       '';
     };
  */

  hardware.keyboard.zsa.enable = true;

  services.openssh.enable = true;

  networking.firewall.enable = false;

  powerManagement = { cpuFreqGovernor = "performance"; };

  /* services.mongodb.enable = true;
     services.redis.enable = true;
  */

  system.stateVersion = "21.05";
}

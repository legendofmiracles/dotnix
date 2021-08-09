{ config, pkgs, lib, ... }:

{
  services.xserver = {
    enable = true;

    videoDrivers = [ "nvidia" ];

    displayManager.lightdm.enable = true;

    windowManager.i3 = {
      enable = true;
      #configFile = "/home/nix/.config/herbstluftwm/autostart";
    };

    libinput = {
      enable = true;
      mouse = {
        accelProfile = "flat";
        middleEmulation = false;
      };
    };
  };

  hardware.nvidia = {
    prime = {
      #offload.enable = true;
      sync.enable = true;

      intelBusId = "PCI:0:2:0";

      nvidiaBusId = "PCI:1:0:0";
    };

    nvidiaPersistenced = true;

    # package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    glxinfo
    xorg.xkill
    xorg.xev
    #xcolor
    xclip
    xdotool
  ];

  services.greetd = {
    #enable = true;
    settings = {
      default_session = {
        command = "${
            lib.makeBinPath [ pkgs.greetd.tuigreet ]
          }/tuigreet --time --cmd startx";
        user = "nix";
      };
    };
  };

}

{ config, pkgs, lib, ... }:

{
  services.xserver = {
    enable = true;

    videoDrivers = [ "nvidia" ];

    displayManager.lightdm.enable = true;

    windowManager.i3.enable = true;

    windowManager.i3.configFile = "/home/nix/.config/i3/config";

    libinput = {
      enable = true;
      mouse.accelProfile = "flat";
    };
  };


  hardware.nvidia = {
    prime = {
      #offload.enable = true;
      sync.enable = true;

      intelBusId = "PCI:0:2:0";

      nvidiaBusId = "PCI:1:0:0";
    };

    #nvidiaPersistenced = true;

    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    glxinfo
    xorg.xkill
    xorg.xev
    xcolor
    xclip
    xdotool
  ];
}

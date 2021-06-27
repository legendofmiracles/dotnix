{ config, pkgs, ... }:

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    videoDrivers = [ "nvidia" ];
    displayManager.startx.enable = true;
    # xkbVariant = "colemak";
    # windowManager.herbstluftwm.enable = true;
  };

  hardware.nvidia.prime = {
    offload.enable = true;
    #sync.enable = true;

    intelBusId = "PCI:0:2:0";

    nvidiaBusId = "PCI:1:0:0";

  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.beta;

  hardware.nvidia.nvidiaPersistenced = true;
  # hardware.nvidiaOptimus.disable = true;

  hardware.opengl.driSupport32Bit = true;

  environment.systemPackages = with pkgs; [
    glxinfo
    xorg.xkill
    xorg.xev
    xcolor
    xclip
    xdotool
  ];

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver = {
    libinput.enable = true;
    libinput.mouse.accelProfile = "flat";
    /*
    config = ''
      Section "InputClass"
            Identifier "mouse accel"
            Driver "libinput"
            MatchIsPointer "on"
            Option "AccelProfile" "flat"
                  Option "AccelSpeed" "0"
                EndSection
    '';
    */
  };
}

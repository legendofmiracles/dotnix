{ config, pkgs, ... }:

{
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  };

  programs.gpg = {
    enable = true;
    # settings = ;
  };

  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "curses";


}

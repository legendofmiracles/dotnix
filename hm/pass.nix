{ config, pkgs, ... }:

{
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    settings = {
      PASSWORD_STORE_DIR = "~/.password-store";
    };
  };

  programs.gpg = {
    enable = true;
    # settings = ;
  };

  services.gpg-agent.enable = true;
  services.gpg-agent.pinentryFlavor = "curses";

}

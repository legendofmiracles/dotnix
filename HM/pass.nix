{ config, pkgs, ... }:

{
  programs.password-store.enable = true;
  programs.password-store.package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
  programs.browserpass.enable = true;
  programs.browserpass.browsers = [ "firefox" ];
}

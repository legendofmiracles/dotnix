{ pkgs, config, lib, ... }:

{
  programs.fish = {
    enable = true;
    vendor.completions.enable = true;
  };

  environment.sessionVariables = {
    NIXOS_CONFIG = "/home/nix/dotnix";
    fish_greeting = "";
  };

  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "dialout" "libvirtd" ];
    shell = pkgs.fish;
  };

  nix = {
    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';
    autoOptimiseStore = true;
    trustedUsers = [ "root" "nix" ];
    gc.automatic = true;
    gc.options = "--delete-older-than 3d";
  };

  environment.systemPackages = with pkgs; [
    man-pages
  ];

  time.timeZone = "America/Guatemala";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
}

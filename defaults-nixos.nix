{ pkgs, config, lib, ... }:

let caches = [
  "https://cache.nixos.org"
  "https://nix-community.cachix.org"
  "https://lom.cachix.org"
]; in
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

    gc = {
      automatic = true;
      options = "--delete-older-than 3d";
      dates = "weekly";
    };

    binaryCaches = caches;

    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lom.cachix.org-1:R0BYXkgRm24m+gHUlYzrI2DxwNEOKWXF1/VdYSPCXyQ="
    ];

    nixPath = [
      "nixpkgs=${pkgs.path}"
      # "home-manager=${home-manager}"
    ];

    trustedBinaryCaches = caches;
  };

  programs.command-not-found.enable = false;

  environment.systemPackages = with pkgs; [
    man-pages
  ];

  time.timeZone = "America/Guatemala";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];
}

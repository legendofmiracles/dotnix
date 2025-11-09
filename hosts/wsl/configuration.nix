{ config, pkgs, lib, ... }: {
  system.stateVersion = "25.05";

  wsl.enable = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs = {
    vim.enable = true;
    fish.enable = true;
    git.enable = true;
  };

  environment.systemPackages = with pkgs; [ (pass.withExtensions(exts: [ exts.pass-otp ])) gnupg pinentry-tty ];
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

}


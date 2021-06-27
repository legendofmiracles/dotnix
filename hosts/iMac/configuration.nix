{ config, pkgs, ... }:

{
  nix.package = pkgs.nixUnstable;

  system.stateVersion = 4;
}

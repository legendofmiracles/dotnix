{ config, pkgs, ... }:

{
  nix.package = pkgs.nixFlakes;
}

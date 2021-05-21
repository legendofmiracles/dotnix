{ config, lib, pkgs, ... }:

{
  services.espanso = {
    # enable = true;
    matches = {
      trigger = ":hi";
      replace = "nerd";
    };
  };
}

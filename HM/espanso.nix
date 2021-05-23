{ config, lib, pkgs, ... }:

{
  services.espanso = {
    enable = true;
    settings = {
      matches = [
        {
          trigger = "rn";
          replace = "right now";
        }
        {
          trigger = "btw";
          replace = "by the way";
        }
      ];
    };
    matches = {
      "tbh" = "to be honest";
      "ty" = "thank you";
    };
  };
}

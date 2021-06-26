{ config, lib, pkgs, ... }:

{
  services.espanso = {
    enable = true;
    # package = pkgs.espanso-no-notify;
    settings = {
      matches = [
        {
          trigger = "ty";
          replace = "thank you";
          word = true;
        }
        {
          trigger = "rn";
          replace = "right now";
          word = true;
        }
      ];
    };
    matches = {
      tbh = "to be honest";
      btw = "by the way";
      wdym = "what do you mean";
      # "the value of pi" = " 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679";
      ":config" = "https://github.com/legendofmiracles/dotnix/tree/master/";
      ":homemanager" =
        "https://nix-community.github.io/home-manager/options.html";
      ":search" = "https://search.nixos.org/";
      ftfy = "fixed that for you";
      irl = "in real life";
      afaik = "as far as I know";
      pls = "please";
      iirc = "if I remember correctly";
      typo = "typographical error";
      idk = "I don't know";
    };
  };
}

{ config, lib, pkgs, ... }:

{
  services.espanso = {
    enable = true;
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
      ":config" = "https://github.com/legendofmiracles/dotnix/tree/master/";
      ":homemanager" = "https://nix-community.github.io/home-manager/options.html";
      ":search" = "https://search.nixos.org/";
      ftfy = "fixed that for you";
      irl = "in real life";
      afaik = "as far as I know";
      pls = "please";
      iirc = "if I remember correctly";
      typo = "typographical error";
    };
  };
}

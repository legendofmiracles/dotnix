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
        {
          trigger = ":config";
          replace = "{{url}}";
          vars = [{
            name = "url";
            type = "script";
            params = {
              args = [
                (pkgs.writeShellScript "espanso-script" ''
                  echo $NIXOS_CONFIG > /tmp/aoirent
                  cmd=$(${pkgs.git}/bin/git -C $NIXOS_CONFIG rev-parse origin)
                  printf https://github.com/legendofmiracles/dotnix/blob/ && printf $cmd | ${pkgs.gnused}/bin/sed s/\n// && printf /
                '')
              ];
              debug = true;
            };
          }];
        }
      ];
    };
    matches = {
      tbh = "to be honest";
      btw = "by the way";
      wdym = "what do you mean";
      # "the value of pi" = " 3.1415926535897932384626433832795028841971693993751058209749445923078164062862089986280348253421170679";
      ":homemanager" =
        "https://nix-community.github.io/home-manager/options.html";
      ":search" = "https://search.nixos.org/";
      ftfy = "fixed that for you";
      afaik = "as far as I know";
      pls = "please";
      iirc = "if I remember correctly";
      idk = "I don't know";
    };
  };
}

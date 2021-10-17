{ config, lib, pkgs, ... }:

{
  services.espanso = {
    enable = true;
    # package = pkgs.espanso-no-notify;
    settings = {
      enable_passive = true;
      passive_key = "CTRL";
      matches = [
        {
          trigger = ":config";
          replace = "{{url}}";
          vars = [{
            name = "url";
            type = "script";
            params = {
              args = [
                (pkgs.writeShellScript "espanso-script" ''
                  cmd=$(${pkgs.git}/bin/git -C $NIXOS_CONFIG rev-parse origin)
                  printf https://github.com/legendofmiracles/dotnix/blob/ && printf $cmd | ${pkgs.gnused}/bin/sed s/\n// && printf /
                '')
              ];
              debug = true;
            };
          }];
        }
        {
          trigger = ":chess";
          replace = "{{url}}";
          passive_only = true;
          vars = [{
            name = "url";
            type = "script";
            params = {
              args = [
                (pkgs.writeShellScript "lichess-script" ''
                  set -e
                  source /run/secrets/variables
                  id=$(echo $(${pkgs.curl}/bin/curl -sS --data "rated=false&clock.limit=$(echo "scale=2;$1*60" | ${pkgs.bc}/bin/bc | ${pkgs.coreutils}/bin/cut -d "." -f 1)&clock.increment=$2" https://lichess.org/api/challenge/open) | ${pkgs.jq}/bin/jq -r .challenge.id)
                  ${pkgs.curl}/bin/curl -sS -X POST https://lichess.org/api/challenge/$id/accept -H "Authorization: Bearer $LICHESS_TOKEN"
                  echo -n https://lichess.org/$id
                  ${pkgs.runtimeShell} -c "${pkgs.coreutils}/bin/sleep 1; ${pkgs.firefox}/bin/firefox https://lichess.org/$id" &
                '')
              ];
              debug = true;
              inject_args = true;
              trim = true;
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
    };
  };
}

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.discord;

in {
  options = {
    services.discord = mkOption {
      type = with types;
        attrsOf (submodule {
          options = {
            desc = mkOption { type = str; };

            content = mkOption { type = str; };

            server = mkOption { type = str; };

            channel = mkOption { type = str; };

            when = mkOption { type = str; };

          };
        });
    };
  };

  config = {
    systemd.services = attrsets.mapAttrs' (name: value:
      nameValuePair name {
        description = value.desc;

        serviceConfig = {
          Type = "simple";
          EnvironmentFile = "/run/secrets/variables";
          ExecStart = ''
            ${pkgs.cliscord}/bin/cliscord -s "${value.server}" -c "${value.channel}" -m "${value.content}" -t "$DISCORD_TOKEN"'';
          Restart = "on-failure";
          RestartSec = 10;
        };
      }) cfg;

    systemd.timers = attrsets.mapAttrs' (name: value:
      nameValuePair name {
        description = value.desc;

        timerConfig = {
          OnCalendar = value.when;
          Unit = "${name}.service";
        };

        wantedBy = [ "timers.target" ];
      }) cfg;
  };
}

{ config, lib, pkgs, ... }:

with lib;

let cfg = config.services.discord-sender;

in {
  options = {
    services.discord-sender = {
      enable = mkEnableOption "discord-sender";
      services = MkOption {
        type = with type;
          attrsOf (submodule {
            options = {
              desc = mkOption { type = string; };

              content = mkOption { type = string; };

              server = mkOption { type = string; };

              channel = mkOption { type = string; };

              when = mkOption { type = string; };

            };
          });
      };
    };
  };

  config = {
    systemd.user.services.${name} = {
      Unit = { Description = desc; };

      Service = {
        Type = "oneshot";
        EnvironmentFile = "/run/secrets/variables";
        ExecStart = ''
          ${pkgs.cliscord}/bin/cliscord -s "${server}" -c "${channel}" -m "${content}" -t "$DISCORD_TOKEN"'';
        Restart = "on-failure";
        RestartSec = 10;
      };
    };

    systemd.user.timers.${name} = {
      Unit = { Description = desc; };

      Timer = {
        OnCalendar = when;
        Unit = "${name}.service";
      };

      Install = { WantedBy = [ "timers.target" ]; };
    };
  };
}

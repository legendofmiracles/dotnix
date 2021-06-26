{ lib, pkgs, desc ? "", content ? "", server ? "", channel ? "", name ? ""
, when ? "", ... }: {

  systemd.user.services.${name} = {
    Unit = { Description = desc; };

    Service = {
      Type = "simple";
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
}

{ config, lib, pkgs, ... }:

{
  home.packages = with pkgs; [ aw-watcher-afk aw-watcher-window aw-webui aw-core aw-server-rust ];

  systemd.user.services.aw-server = {
      Unit = {
        Description = "activity-watch server";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = "${pkgs.aw-server-rust}/bin/aw-server";
        Restart = "always";
        RestartSec = 3;
      };
  };

  systemd.user.services.aw-window = {
      Unit = {
        Description = "activity-watch window";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = "${pkgs.aw-watcher-window}/bin/aw-watcher-window";
        Restart = "always";
        RestartSec = 3;
      };
  };

  systemd.user.services.aw-afk = {
      Unit = {
        Description = "activity-watch afk";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Install = { WantedBy = [ "graphical-session.target" ]; };

      Service = {
        ExecStart = "${pkgs.aw-watcher-afk}/bin/aw-watcher-afk";
        Restart = "always";
        RestartSec = 3;
      };
  };

}

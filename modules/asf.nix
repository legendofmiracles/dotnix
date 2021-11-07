{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.asf;
  asf-config = pkgs.writeText "ASF.json" builtins.toJSON (cfg.config // {
    # we disable it because ASF cannot update itself anyways
    # and nixos takes care of restarting the service
    AutoRestart = false;
    UpdateChannel = 0;
  });

  mkBot = n: c:
    builtins.toJSON (c.settings // {
      SteamLogin = if c.username == "" then n else c.username;
      # we set it to the password file path, because we will replace it later on
      SteamPassword = c.password;
      Enabled = c.enabled;
    });

in {
  options.services.asf = {
    enable = mkOption {
      type = types.bool;
      description = ''
        If enabled, starts a Archis Steam Farm service.
        Any user in the <literal>asf<literal> group can connect to the console with <literal>tmux -S ${cfg.dataDir}/asf.sock attach</literal>
      '';
      default = false;
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ArchiSteamFarm;
      description = "Package to use";
    };

    dataDir = mkOption {
      type = types.path;
      default = "/var/lib/asf";
      description = "State directory of Archis-Steam-Farm";
    };

    config = mkOption {
      type = types.attrs;
      description = ''
        The ASF.json file, all the options are documented here: https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Configuration#global-config.
        Do note that AutoRestart is automatically set to false, since nix takes care of updating everything.
        UpdateChannel is also set to 0 for the same reason.
        You should try to keep ASF up to date since upstream does not provide support for anything but hte latest version and you're exposing yourself to all kinds of issues - as is outlined here: https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Configuration#updateperiod
      '';
      example = {
        Headless = true;
        Statistics = false;
      };
      default = { };
    };
    bots = mkOption {
      type = types.attrsOf types.submodule {
        options = {
          username = mkOption {
            type = types.str;
            description =
              "Name of the user to log in. Default is attribute name.";
            default = "";
          };
          password = mkOption {
            type = types.path;
            description = "Path to a file containig the password. The file must be readable by the <literal>asf</literal> user/group.";
          };
          enabled = mkOption {
            type = types.bool;
            default = true;
          };
          settings = mkOption {
            type = types.attrs;
            description =
              "Additional settings that are documented here: https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Configuration#bot-config";
            default = { };
          };
        };
      };
      description = ''
        Bots name and configuration
      '';
      example = {
        exampleBot = {
          username = "alice";
          password = "/my/super/secret/password";
          settings = { SteamParentalCode = "1234"; };
        };
      };
      default = { };
    };
  };

  config = mkIf cfg.enable {

    users = {
      users.asf = {
        home = cfg.dataDir;
        createHome = true;
        isSystemUser = true;
        group = "asf";
        description = "Archis-Steam-Farm service user";
      };
      groups.asf = { };
    };

    systemd.services.asf = {
      description = "Archis-Steam-Farm Service";
      after = [ "network.target" ];
      path = [ cfg.package ];

      serviceConfig = {
        Type = "simple";
        WorkingDirectory = cfg.dataDir;
        #Type = "forking";
        #GuessMainPID = true;

        #ExecStart = "${pkgs.tmux}/bin/tmux -S ${cfg.dataDir}/asf.sock new -d ${pkgs.ArchiSteamFarm}/bin/ArchiSteamFarm --path ${cfg.dataDir}";
        ExecStart =
          "${pkgs.ArchiSteamFarm}/bin/ArchiSteamFarm --path ${cfg.dataDir}";
      };
      /* postStart = ''
         sleep 1
         ${pkgs.coreutils}/bin/chmod 660 ${cfg.dataDir}/asf.sock
         ${pkgs.coreutils}/bin/chgrp asf ${cfg.dataDir}/asf.sock
         '';
      */

      preStart = ''
        # we remove config to have no complexity when creating the required files/directories
        rm -rf config/
        mkdir config
        ln -s ${asf-config} config/ASF.json
        #''${concatMapStrings (x: "ln -s ${builtins.elemAt x 0} ${
          builtins.elemAt x 1
        }") (attrsets.mapAttrsToList (name: config:
        #  [(pkgs.writeText name config) name]
        #) cfg.bots)}
        ''${concatMapStrings (x: \'\'
          cat <<EOF
          ${x}
          EOF | ${pkgs.jq}/bin/jq '.SteamPassword |= ["$(cat )"] + . + [")"]]'
        ) attrsets.mapAttrsToList mkBot cfg.bots}
      '';
    };
  };
}

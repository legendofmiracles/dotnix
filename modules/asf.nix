{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.asf;
  asf-config = pkgs.writeText "ASF.json" (builtins.toJSON (cfg.config // {
    # we disable it because ASF cannot update itself anyways
    # and nixos takes care of restarting the service
    AutoRestart = false;
    UpdateChannel = 0;
  }));

  mkBot = n: c:
    builtins.toJSON (c.settings // {
      SteamLogin = if c.username == "" then n else c.username;
      # we set it to the password file path, because we will replace it later on
      SteamPassword = c.password;
      Enabled = c.enabled;
      name = n;
    });

in {
  options.services.asf = {
    enable = mkOption {
      type = types.bool;
      description = ''
        If enabled, starts the Archis Steam Farm service.
        Any user in the <literal>asf<literal> group can connect to the console with <literal>tmux -S ${cfg.dataDir}/asf.sock attach</literal>
      '';
      default = false;
    };

    web-ui = mkOption {
      type = types.submodule {
        options = {
          enable = mkEnableOption
            "Wheter to start the web-ui. This is the preffered way of configuring things such as the steam guard token.";

          package = mkOption {
            type = types.package;
            default = pkgs.ASF-ui;
            description =
              "Web ui package to use. Contents must be in $out/lib/dist.";
          };
        };
      };
      default = {
        enable = true;
        package = pkgs.ASF-ui;
      };
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
      type = types.attrsOf (types.submodule {
        options = {
          username = mkOption {
            type = types.str;
            description =
              "Name of the user to log in. Default is attribute name.";
            default = "";
          };
          password = mkOption {
            type = types.path;
            description =
              "Path to a file containig the password. The file must be readable by the <literal>asf</literal> user/group.";
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
      });
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

    systemd.services = {
      asf = {
        description = "Archis-Steam-Farm Service";
        after = [ "network.target" ];

        serviceConfig = {
          User = "asf";
          Group = "asf";
          WorkingDirectory = cfg.dataDir;
          Type = "simple";
          ExecStart =
            "${cfg.package}/bin/ArchiSteamFarm --service --process-required";
          #PrivateTmp = true;
        };

        environment = {
          ASF_PATH = cfg.dataDir;
        };

        preStart = ''
          pwd
          set -x
          # we remove config to have no complexity when creating the required files/directories
          rm -rf config/*.json
          rm -rf www
          mkdir config || true
          ln -s ${asf-config} config/ASF.json
          echo -e '${
            lib.strings.concatStringsSep "\\n"
            (attrsets.mapAttrsToList mkBot cfg.bots)
          }' \
          | while read -r line; do
            name="$(${pkgs.jq}/bin/jq -r .name <<< "$line")"
            password_file="$(${pkgs.jq}/bin/jq -r .SteamPassword <<< "$line")"
            password="$(< "$password_file")"
            ${pkgs.jq}/bin/jq -r "del(.name) | .SteamPassword = \"''${password}"\" <<< "$line" > "config/''${name}".json
          done

          ${if cfg.web-ui.enable then ''
            mkdir www
            cp -r ${cfg.web-ui.package}/lib/dist/* www/
            chmod u+w -R www/
          '' else
            ""}
        '';
      };
    };
  };
}

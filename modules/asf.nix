#TODO: edit nixpkgs/nixos/modules/misc/ids.nix

{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.archisteamfarm;
  asf-config = pkgs.writeText "ASF.json" (builtins.toJSON (cfg.config // {
    # we disable it because ASF cannot update itself anyways
    # and nixos takes care of restarting the service
    AutoRestart = false;
    UpdateChannel = 0;
    Headless = true;
  }));

  mkBot = n: c:
    builtins.toJSON (c.settings // {
      SteamLogin = if c.username == "" then n else c.username;
      SteamPassword = c.passwordFile;
      # sets the password format to file (https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Security#file)
      PasswordFormat = 4;
      Enabled = c.enabled;
      name = n;
    });

in {
  options.services.archisteamfarm = {
    enable = mkOption {
      type = types.bool;
      description = ''
        If enabled, starts the Archis Steam Farm service.
        For configuring the SteamGuard token you will need to use the web-ui, which is enabled by default. On http://127.0.0.1:1242/commands enter <literal>input <BOT> SteamGuard <code from email>. Read more about the command here: https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Commands#input-command. If you disable the web-ui you should still be able to use IPC to set all required runtime values.
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
      example = {
        enable = false;
      };
    };

    package = mkOption {
      type = types.package;
      default = pkgs.ArchiSteamFarm;
      description =
        "Package to use. Should always be the latest version, for security reasons and since this module uses very new features.";
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
        Headless is also set to true, since there is no way to provide input via a systemd service.
        You should try to keep ASF up to date since upstream does not provide support for anything but hte latest version and you're exposing yourself to all kinds of issues - as is outlined here: https://github.com/JustArchiNET/ArchiSteamFarm/wiki/Configuration#updateperiod
      '';
      example = {
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
          passwordFile = mkOption {
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
          passwordFile = "/my/super/secret/password";
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
            "${cfg.package}/bin/ArchiSteamFarm --path ${cfg.dataDir} --process-required";

          # mostly copied from the default systemd service
          PrivateTmp = true;
          LockPersonality = true;
          PrivateDevices = true;
          PrivateIPC = true;
          PrivateMounts = true;
          PrivateUsers = true;
          ProtectClock = true;
          ProtectControlGroups = true;
          ProtectHostname = true;
          ProtectKernelLogs = true;
          ProtectKernelModules = true;
          ProtectKernelTunables = true;
          ProtectProc = "invisible";
          ProtectSystem = "full";
          RemoveIPC = true;
          RestrictAddressFamilies = "AF_INET AF_INET6";
          RestrictNamespaces = true;
          RestrictRealtime = true;
          RestrictSUIDSGID = true;
        };

        preStart = ''
          # we remove config to have no complexity when creating the required files/directories
          mkdir config || true
          rm -r config/*.json
          rm -r www
          ln -s ${asf-config} config/ASF.json
          echo -e '${
            lib.strings.concatStringsSep "\\n"
            (attrsets.mapAttrsToList mkBot cfg.bots)
          }' \
          | while read -r line; do
            name="$(${pkgs.jq}/bin/jq -r .name <<< "$line")"
            ${pkgs.jq}/bin/jq -r "del(.name)" <<< "$line" > "config/''${name}".json
          done

          ${if cfg.web-ui.enable then ''
            ln -s ${cfg.web-ui.package}/lib/dist www
          '' else
            ""}
        '';
      };
    };
  };
}

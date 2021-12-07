{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.minecraft-server;

  mods = lib.strings.concatStringsSep "\n" (x: x) cfg.fabric.mods;

  # We don't allow eula=false anyways
  eulaFile = builtins.toFile "eula.txt" ''
    # eula.txt managed by NixOS Configuration
    eula=true
  '';

  whitelistFile = pkgs.writeText "whitelist.json" (builtins.toJSON
    (mapAttrsToList
      (n: v: {
        name = n;
        uuid = v;
      })
      cfg.whitelist));

  cfgToString = v: if builtins.isBool v then boolToString v else toString v;

  serverPropertiesFile = pkgs.writeText "server.properties" (''
    # server.properties managed by NixOS configuration
  '' + concatStringsSep "\n"
    (mapAttrsToList (n: v: "${n}=${cfgToString v}") cfg.serverProperties));

  # To be able to open the firewall, we need to read out port values in the
  # server properties, but fall back to the defaults when those don't exist.
  # These defaults are from https://minecraft.gamepedia.com/Server.properties#Java_Edition_3
  defaultServerPort = 25565;

  serverPort = cfg.serverProperties.server-port or defaultServerPort;

  rconPort =
    if cfg.serverProperties.enable-rcon or false then
      cfg.serverProperties."rcon.port" or 25575
    else
      null;

  queryPort =
    if cfg.serverProperties.enable-query or false then
      cfg.serverProperties."query.port" or 25565
    else
      null;

in
{
  options = {
    services.minecraft-server = {

      enable = mkEnableOption ''
        If enabled, start a Minecraft Server. The server
        data will be loaded from and saved to
        <option>services.minecraft-server.dataDir</option>.'';

      declarative = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to use a declarative Minecraft server configuration.
          Only if set to <literal>true</literal>, the options
          <option>services.minecraft-server.whitelist</option> and
          <option>services.minecraft-server.serverProperties</option> will be
          applied.
        '';
      };

      eula = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether you agree to
          <link xlink:href="https://account.mojang.com/documents/minecraft_eula">
          Mojangs EULA</link>. This option must be set to
          <literal>true</literal> to run Minecraft server.
        '';
      };

      dataDir = mkOption {
        type = types.path;
        default = "/var/lib/minecraft";
        description = ''
          Directory to store Minecraft database and other state/data files.
        '';
      };

      openFirewall = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to open ports in the firewall for the server.
        '';
      };

      whitelist = mkOption {
        type =
          let
            minecraftUUID = types.strMatching
              "[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}" // {
              description = "Minecraft UUID";
            };
          in
          types.attrsOf minecraftUUID;
        default = { };
        description = ''
          Whitelisted players, only has an effect when
          <option>services.minecraft-server.declarative</option> is
          <literal>true</literal> and the whitelist is enabled
          via <option>services.minecraft-server.serverProperties</option> by
          setting <literal>white-list</literal> to <literal>true</literal>.
          This is a mapping from Minecraft usernames to UUIDs.
          You can use <link xlink:href="https://mcuuid.net/"/> to get a
          Minecraft UUID for a username.
        '';
        example = literalExample ''
          {
            username1 = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx";
            username2 = "yyyyyyyy-yyyy-yyyy-yyyy-yyyyyyyyyyyy";
          };
        '';
      };

      serverProperties = mkOption {
        type = with types; attrsOf (oneOf [ bool int str ]);
        default = { };
        example = literalExample ''
          {
            server-port = 43000;
            difficulty = 3;
            gamemode = 1;
            max-players = 5;
            motd = "NixOS Minecraft server!";
            white-list = true;
            enable-rcon = true;
            "rcon.password" = "hunter2";
          }
        '';
        description = ''
          Minecraft server properties for the server.properties file. Only has
          an effect when <option>services.minecraft-server.declarative</option>
          is set to <literal>true</literal>. See
          <link xlink:href="https://minecraft.gamepedia.com/Server.properties#Java_Edition_3"/>
          for documentation on these values.
        '';
      };

      package = mkOption {
        type = types.package;
        default = pkgs.minecraft-server;
        defaultText = "pkgs.minecraft-server";
        example = literalExample "pkgs.minecraft-server_1_12_2";
        description = "Version of minecraft-server to run.";
      };

      jvmOpts = mkOption {
        type = types.separatedString " ";
        default = "-Xmx2048M -Xms2048M";
        # Example options from https://minecraft.gamepedia.com/Tutorials/Server_startup_script
        example = "-Xmx2048M -Xms4092M -XX:+UseG1GC -XX:+CMSIncrementalPacing "
          + "-XX:+CMSClassUnloadingEnabled -XX:ParallelGCThreads=2 "
          + "-XX:MinHeapFreeRatio=5 -XX:MaxHeapFreeRatio=10";
        description = "JVM options for the Minecraft server.";
      };

      fabric = mkOption {
        type = types.submodule {
          options = {
            enable = mkOption {
              default = false;
              type = types.bool;
              description = ''
                Enable fabric (https://fabricmc.net/).
                If enabled you can use all options from normal minecraft, except for <option>services.minecraft-server.package</option>; use <option>services.minecraft-server.fabric.version instead.
              '';
            };

            minecraftVersion = mkOption {
              type = types.str;
              description = "Minecraft version to install, as long as fabric supports it.";
            };

            loaderVersion = mkOption {
              type = types.str;
              description = "Fabric version to install. Leave empty for newest.";
            };

            loaderAutoUpdate = mkOption {
              type = types.bool;
              description = "Wether to auto-update the fabric loader version, and check for updates every time the server startes.";
            };

            mods = mkOption {
              type = with types; listOf anything;
              default = [ ];
              description = ''
                Mods to place in the mods directory. You can fetch the mods with <option>fetchurl</option> and friends.
              '';
              example = ''
                [
                  # fetches it from the internet
                  (fetchurl {
                    url = "example.org/mod.jar";
                    sha256 = lib.fakeSha256;
                  })

                  # real path
                  ./mod.jar

                  # copies it into the nix store
                  ''${./mod.jar}

                  # fetch a tarball and only use a specific mod
                  "''${fetchzip {
                        url = "example.org/mods.zip";
                        sha256 = lib.fakeSha256;
                      }}/example.jar"
                ]
              '';
            };

            fabricApi = {
              type = types.submodule {
                options = {
                  install = mkOption {
                    type = with types; bool;
                    default = true;
                    description = ''
                      Wether to install the fabric api, latest version for your selected minecraft version will be downloaded from https://modrinth.com.
                    '';
                  };
                };
              };
              default = {
                install = true;
              };
            };
          };
        };
        default = {
          enable = false;
          minecraftVersion = "";
          loaderVersion = "";
          loaderAutoUpdate = false;
          mods = [ ];
          fabricApi = {
            install = true;
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {

    users.users.minecraft = {
      description = "Minecraft server service user";
      home = cfg.dataDir;
      createHome = true;
      isSystemUser = true;
      group = "minecraft";
    };

    users.groups.minecraft = { };

    systemd.services.minecraft-server = {
      description = "Minecraft Server Service";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];

      serviceConfig = {
        ExecStart = if !cfg.fabric.enable then "${cfg.package}/bin/minecraft-server ${cfg.jvmOpts}" else "${pkgs.jre8_headless}/bin/java -jar fabric-server-launch.jar ";
        Restart = "always";
        User = "minecraft";
        WorkingDirectory = cfg.dataDir;
      };

      preStart = ''
        set -x
        ln -sf ${eulaFile} eula.txt
      '' + (if cfg.declarative then ''

        if [ -e .declarative ]; then

          # Was declarative before, no need to back up anything
          ln -sf ${whitelistFile} whitelist.json
          cp -f ${serverPropertiesFile} server.properties

        else

          # Declarative for the first time, backup stateful files
          ln -sb --suffix=.stateful ${whitelistFile} whitelist.json
          cp -b --suffix=.stateful ${serverPropertiesFile} server.properties

          # server.properties must have write permissions, because every time
          # the server starts it first parses the file and then regenerates it..
          chmod +w server.properties
          echo "Autogenerated file that signifies that this server configuration is managed declaratively by NixOS" \
            > .declarative

        fi
      '' else ''
        if [ -e .declarative ]; then
          rm .declarative
        fi
      '') + (if cfg.fabric.enable then ''
        # file to check if we have installed the specific version of the minecraft server already
        if [ "$(cat .fabric-version 2> /dev/null)" != "${cfg.fabric.version}" ]; then
          set -x
          ${pkgs.fabric-installer}/bin/fabric-installer server -mcversion ${cfg.fabric.version} -downloadMinecraft ${if cfg.fabric.loaderVersion != "" then cfg.fabric.loaderVersion else ""}

          echo ${cfg.fabric.version} > .fabric-version
        fi

        # checks if we need to install a new fabric api version
        if [ "$(cat mods/.api-mod 2> /dev/null)" != "${mods}" ]; then
          mkdir mods || true
          ${pkgs.curl}/bin/curl "$(${pkgs.curl}/bin/curl https://api.modrinth.com/api/v1/mod/P7dR8mSH/version | ${pkgs.jq}/bin/jq -r '[.[] | select(.game_versions[] == "${cfg.fabric.version}")] | .[0].files[0].url')" -o mods/fabric-api.jar

          # links all of the mods in place
          ${lib.strings.concatMapStrings (x: "ln -fs ${x} mods/${lib.concatStringsSep "-" (builtins.tail (lib.splitString "-" (builtins.baseNameOf x)))}") cfg.fabric.mods}
          echo "${lib.strings.concatStrings cfg.fabric.mods}" > mods/.mods
        fi
      '' else '''');
    };

    networking.firewall = mkIf cfg.openFirewall (if cfg.declarative then {
      allowedUDPPorts = [ serverPort ];
      allowedTCPPorts = [ serverPort ] ++ optional (queryPort != null) queryPort
        ++ optional (rconPort != null) rconPort;
    } else {
      allowedUDPPorts = [ defaultServerPort ];
      allowedTCPPorts = [ defaultServerPort ];
    });

    assertions = [{
      assertion = cfg.eula;
      message = "You must agree to Mojangs EULA to run minecraft-server."
        + " Read https://account.mojang.com/documents/minecraft_eula and"
        + " set `services.minecraft-server.eula` to `true` if you agree.";
    }];

  };
}

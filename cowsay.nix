{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.programs.cowsay;

  mkCow = cow: ''
    $the_cow = <<EOC;
      ${builtins.replaceStrings [ "\n" ] [ "\n  " ] cow}
    EOC
  '';

  mkCows = cows:
    let
      mkCowFile = name: cow: {
        "cowsayCow${name}" = {
          target = "cows/${name}.cow";
          text = mkCow cow;
        };
      };
    in mkMerge (attrsets.mapAttrsToList mkCowFile cows);

in {
  options.programs.cowsay = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        Whether to enable cowsay.
      '';
    };

    package = mkOption {
      type = types.path;
      description = ''
        The cowsay version to use.
      '';
      default = pkgs.cowsay;
      example = literalExample "pkgs.cowsay";
    };

    cows = mkOption {
      type = types.attrsOf types.lines;
      default = { };
      description = ''
        Set of cows; Backslashes have to be escaped
      '';
      example = {
        giraffe = ''
          $thoughts
           $thoughts
            $thoughts
               ^__^
               (oo)
               (__)
                 \\ \\
                  \\ \\
                   \\ \\
                    \\ \\
                     \\ \\
                      \\ \\
                       \\ \\
                        \\ \\______
                         \\       )\\/\\/\\
                          ||----w |
                          ||     ||
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    /*assertions = [{
      # we gotta check this because we write our own cowsay programs into the environment, see above
      # and the path order can't guarantee that the one defined in this module will be the first
      assertion = elem "out" (lists.findFirst (x: x == pkgs.cowsay) {meta.outputsToInstall = [];} config.environment.systemPackages).meta.outputsToInstall;
      message =
        "You can't have cowsay in the system packages and enable it with programs.cowsay.enable";
    }];
    */

    environment = {
      systemPackages = with pkgs; [
        (writeShellScriptBin "cowsay" ''
          export COWPATH="/etc/cows:${cfg.package}/share/cows"
          "${cfg.package}/bin/cowsay" $@
        '')
        (writeShellScriptBin "cowthink" ''
          export COWPATH="/etc/cows:${cfg.package}/share/cows"
          "${cfg.package}/bin/cowthink" $@
        '')
        # installs the man pages
        (cowsay.overrideAttrs (oldAttrs: {
          meta = oldAttrs.meta // {
            outputsToInstall = [ "man" ];
          };
        }))
      ];

      etc = mkCows cfg.cows;
    };
  };
}

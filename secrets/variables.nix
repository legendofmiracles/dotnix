{ config, pkgs, lib, ... }:

let
  variables = builtins.fromJSON (builtins.readFile /home/nix/dotnix/secrets/variables.json);
in
{
  home.sessionVariables = lib.listToAttrs (lib.lists.forEach variables (x:
      {
        name = x.name;
        value = x.value;
      }
    )
  );
}

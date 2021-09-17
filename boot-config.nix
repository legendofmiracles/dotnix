{config, pkgs, lib, modulesPath, ...}:
{
  imports = [
    (modulesPath + "/installer/cd-dvd/installation-cd-base.nix")
    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    (modulesPath +  "/installer/cd-dvd/channel.nix")
  ];
}

{ pkgs, lib, ... }:

{
  users = {
    users.nix-build-user = {
      description = "User used for distributed builds";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIONNQcvhcUySNuuRKroWNAgSdcfy7aqO3UsezT/C/XAQ legendofmiracles@protonmail.com"
      ];
      isSystemUser = true;
      group = "nix-build-user";
      shell = pkgs.bashInteractive;
    };
    groups.nix-build-user = { };
  };

  nix.trustedUsers = [ "nix-build-user" ];
}

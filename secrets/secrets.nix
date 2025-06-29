let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEt1o+6eRyMK0c+xiwAsDWn/PH+47VzDSzuMmyokSepc"
  ];

  systems = [
    # pi-kb
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIB+pKRYKPQs4WirbvN8j54Q31R6bm+0dXmm9IGlMtocE"
  ];

in {
  # also used as the general password for basically any other service
  "photoprism.age".publicKeys = systems ++ users;

  # asf
  "steam.age".publicKeys = systems ++ users;
  "steam-jonas.age".publicKeys = systems ++ users;

  "mail.age".publicKeys = systems ++ users;
  "services-env.age".publicKeys = systems ++ users;

  # duplicity
  "backup-ssh-key.age".publicKeys = systems ++ users;
  "backup-encryption-pass.age".publicKeys = systems ++ users;

  #website protection
  "website-pass.age".publicKeys = systems ++ users;
}

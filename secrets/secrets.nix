let
  user1 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBybp2ZGdW5VTpI0gPDaxVWy0DBEH9DJNqK6bXe4dzfB legendofmiracles@protonmail.com";
  userPi =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFjdbT/pxlfzMJjfnDWhk2EwWt809M/YsP2vABRjRtXu legendofmiracles@protonmail.com";
  users = [ user1 userPi ];

  system1 =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtX31mOmvoI97JCoNGDjo8Nqker9tid14Pkz/LklRIQ";
  piSystem =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH9Iplu28K+DBrpEcTdQ+wS8yNmSaCCvzuhYOspoyWR4";
  systems = [ system1 piSystem ];
in {
  "wpa_supplicant.conf.age".publicKeys = users ++ systems;
  "variables.age".publicKeys = users ++ systems;
}

let
  users = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBybp2ZGdW5VTpI0gPDaxVWy0DBEH9DJNqK6bXe4dzfB legendofmiracles@protonmail.com"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIONNQcvhcUySNuuRKroWNAgSdcfy7aqO3UsezT/C/XAQ legendofmiracles@protonmail.com"
  ];

  systems = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtX31mOmvoI97JCoNGDjo8Nqker9tid14Pkz/LklRIQ"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDJeRZ0XZiYk59miA9pOPBqQvHsxRXQUHjlq29qoxINg"
  ];
in {
  #"wpa_supplicant.conf.age".publicKeys = users ++ systems;
  "variables.age".publicKeys = users ++ systems;
}

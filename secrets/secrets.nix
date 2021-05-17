let
  user1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBybp2ZGdW5VTpI0gPDaxVWy0DBEH9DJNqK6bXe4dzfB legendofmiracles@protonmail.com";
  userPi = "";
  users = [ user1 ];

  system1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMtX31mOmvoI97JCoNGDjo8Nqker9tid14Pkz/LklRIQ";
  piSystem = "";
  systems = [ system1 ];
in
{
  "wpa_supplicant.conf.age".publicKeys = users ++ systems;
  "variables.age".publicKeys = users ++ systems;
}

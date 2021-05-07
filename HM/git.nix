{ config, pkgs, ... }:

{
  programs.git = {
    enable = true;
    userName = "legendofmiracles";
    userEmail = "legendofmiracles@protonmail.com";
    signing = {
      key = "CC50 F82C 985D 2679 0703  AF15 19B0 82B3 DEFE 5451";
      signByDefault = true;
    };  
    aliases = {
      "lg" = "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";
      "gud" = "commit -am";
    };
  };
}

{ config, pkgs, ... }:

{
  home.packages = with pkgs; [ git-lfs git-open gh ];

  programs.git = {
    enable = true;
    userName = "legendofmiracles";
    userEmail = "legendofmiracles@protonmail.com";
    signing = {
      key = "CC50 F82C 985D 2679 0703  AF15 19B0 82B3 DEFE 5451";
      signByDefault = true;
    };
    aliases = {
      "lg" =
        "log --graph --abbrev-commit --decorate --format=format:'%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all";

      "gud" = "commit -am";

      "related" = ''
        !function git_related() { if git rev-list $1 | grep -q $2 ; then echo "$2 is ancestor of $1" ; elif git rev-list $2 | grep -q $1 ; then echo "$1 is ancestor of $2" ; else echo "$1 unrelated to $2" ; fi } ; git_related $1'';

      "compare-branches" =
        "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr)%Creset' --abbrev-commit --date=relative";
        amend = ''
          !f() { git add $@ && git commit --amend --no-edit }; f $@
        '';
    };
    extraConfig = {
      url = {
        "ssh://git@github.com" = { insteadOf = [ "https://github.com" "gh" ]; };
      };
      url = { "ssh://git@gitlab.com" = { insteadOf = "https://gitlab.com"; }; };
      url = {
        "ssh://git@bitbucket.org" = { insteadOf = "https://bitbucket.org"; };
      };
      pull = { twohead = "ort"; };
      advice = {
        #  detachedHead = false;
      };
      init = { defaultBranch = "master"; };
      rebase = { abbreviateCommands = true; };
      pack = { threads = 0; };
      core = { pager = "${pkgs.delta}/bin/delta"; };
      interactive = { diffFilter = "${pkgs.delta}/bin/delta --color-only"; };
      delta = {
        navigate = true;
        features = "side-by-side line-numbers decorations";
      };
    };
  };
}

{ config, pkgs, ... }:

{
  home.file = {
    ".newsboat/urls".text = ''
      https://repology.org/maintainer/legendofmiracles%40protonmail.com/feed-for-repo/nix_unstable/atom
    '';
    ".newsboat/config".text = ''
      include ${pkgs.newsboat}/share/doc/newsboat/contrib/colorschemes/plain
    '';
  };

  home.packages = [ pkgs.newsboat ];
}

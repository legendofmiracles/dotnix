final: prev: {
  alacritty-ligatures = prev.callPackage ./alacritty-ligatures { };
  /*inherit (prev.callPackages ./activitywatch { inherit npmlock2nix; })
    aw-core aw-server-rust aw-qt aw-watcher-afk aw-watcher-window aw-webui;
    */
  lucky-commit = prev.callPackage ./lucky-commit { };
  cliscord = prev.callPackage ./cliscord { };
}

final: prev: {
  alacritty-ligatures = prev.callPackage ./alacritty-ligatures { };
  /* inherit (prev.callPackages ./activitywatch { inherit npmlock2nix; })
     aw-core aw-server-rust aw-qt aw-watcher-afk aw-watcher-window aw-webui;
  */
  lucky-commit = prev.callPackage ./lucky-commit { };
  cliscord = prev.callPackage ./cliscord { };
  st-patched = prev.callPackage ./st-patched { };
  steam-patched = prev.callPackage ./steam { };
  keymapviz = prev.callPackage ./keymapviz { };
  mori = prev.callPackage ./mori { };
  espanso-no-notify = prev.callPackage ./espanso { };
  discover = prev.callPackage ./discover { };
  autobahn = prev.callPackage ./autobahn { };
  present = prev.callPackage ./present { };
  ab-street = prev.callPackage ./ab-street { };
}

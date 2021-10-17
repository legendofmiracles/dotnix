final: prev: rec {
  alacritty-ligatures = prev.callPackage ./alacritty-ligatures { };
  /* inherit (prev.callPackages ./activitywatch { inherit npmlock2nix; })
     aw-core aw-server-rust aw-qt aw-watcher-afk aw-watcher-window aw-webui;
  */
  activitywatch = prev.callPackage ./activitywatch { };
  lucky-commit = prev.callPackage ./lucky-commit { };
  cliscord = prev.callPackage ./cliscord { };
  st-patched = prev.callPackage ./st-patched { };
  keymapviz = prev.callPackage ./keymapviz { };
  mori = prev.callPackage ./mori { };
  discover = prev.callPackage ./discover { };
  autobahn = prev.callPackage ./autobahn { };
  present = prev.callPackage ./present { };
  ab-street = prev.callPackage ./ab-street { };
  gd-launcher = prev.callPackage ./gdlauncher { };

  # freelancing
  opm-common = prev.callPackage ./opm-simulators/common.nix { };
  opm-material = prev.callPackage ./opm-simulators/material.nix {
    inherit opm-common dune-common;
  };
  opm-grid = prev.callPackage ./opm-simulators/grid.nix {
    inherit dune-common opm-common dune-geometry dune-grid dune-istl;
  };
  dune-common = prev.callPackage ./opm-simulators/dune/common.nix { };
  dune-grid = prev.callPackage ./opm-simulators/dune/grid.nix {
    inherit dune-common dune-geometry;
  };
  dune-geometry = prev.callPackage ./opm-simulators/dune/geometry.nix {
    inherit dune-common;
  };
  dune-istl =
    prev.callPackage ./opm-simulators/dune/istl.nix { inherit dune-common; };
}

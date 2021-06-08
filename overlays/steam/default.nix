{ steam, ibus, ... }:

(steam.override {
      extraPkgs = pkgs: [
        ibus
];})

layout:

.
├── HM - home-manager related configs, can usually be identified by name
│
├── hosts - directory for hosts
│   │
│   ├── pain - the host "pain"
│   │
│   └── pi - you guessed it, the host "pi"
│
├── overlays - a overlay dir which calls other dirs which have default.nix's inside them. Done so that it's as close to nixpkgs as possible
│   │
│   ├── activitywatch
│   │
│   ├── alacritty-ligatures
│   │
│   ├── cliscord
│   │
│   ├── lucky-commit
│   │
│   └── st-patched
│
├── secrets - secrets :flushed:
│
└── tests - currently not used.

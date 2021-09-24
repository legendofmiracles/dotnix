layout:
```
.
├── hm -- all home manager related files
├── hosts -- host specific configuration
│   ├── iMac
│   ├── pain
│   └── pi
├── modules -- normal nixos modules, some might be for home-manager
├── overlays -- varous overlays
└── secrets -- secrets like environment variables, all encrypted... don't even think about it

.
├── defaults-nixos.nix -- defaults, applied to all hosts
├── distributed-build-host.nix -- configuration for enabling cross compilation to my rpi
├── flake.lock
├── flake.nix -- flake file, the root of all evil
├── fonts.nix -- font configuration
├── hm -- all home-manager related files
│   ├── alacritty.nix
│   ├── aw.nix
│   ├── colors.nix
│   ├── defaults.nix
│   ├── dunst.nix
│   ├── espanso.nix
│   ├── firefox.nix
│   ├── fish.nix
│   ├── git.nix
│   ├── gtk.nix
│   ├── htop.nix
│   ├── mangohud.nix
│   ├── mori.nix
│   ├── mpv.nix
│   ├── neofetch.nix
│   ├── newsboat.nix
│   ├── nvim.nix
│   ├── pass.nix
│   ├── proton.nix
│   ├── qt.nix
│   ├── shell-scripts.nix
│   └── xorg-hm.nix
├── hosts -- host specific configuration
│   ├── iMac
│   ├── pain
│   └── pi
├── LICENSE -- mit license
├── modules -- normal nixos/home-manager modules
│   ├── binfmt.nix
│   ├── cowsay.nix
│   ├── discord-message-sender.nix
│   └── espanso-m.nix
├── network.nix -- networking configuration
├── other-files -- stuff like firefox addon configuration, i wish this could also be configured with nix :(
├── overlays -- nixpkgs overlays, as close to the nixpkgs style as it can get
│   ├── ab-street
│   ├── activitywatch
│   ├── alacritty-ligatures
│   ├── autobahn
│   ├── cliscord
│   ├── ddnet
│   ├── default.nix
│   ├── discover
│   ├── espanso
│   ├── keymapviz
│   ├── lucky-commit
│   ├── mori
│   ├── present
│   ├── qemu
│   ├── steam
│   └── st-patched
├── printer.nix -- printer config (doesn't work)
├── readme.md -- the file you're reading
├── secrets -- secrets like passwords that
│   ├── secrets.nix
│   ├── variables.age
│   ├── wifi.json.age
│   └── wpa_supplicant.conf.age
├── v4l2.nix -- fake camera configuration
└── xorg.nix -- xorg configuration

24 directories, 66 files
```

To test this configuration on your own PC: `nixos-rebuild build-vm`
Default username is `nix`, with password: `nix`.

If my configuration helped you, stars would be much appreciated :D

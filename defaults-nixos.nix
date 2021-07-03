{ pkgs, config, lib, inputs, ... }:

let
  mkCache = name: "https://${name}.cachix.org";

  caches = [
    (mkCache "lom")
    "https://cache.nixos.org"
    (mkCache "neovim-nightly")
    (mkCache "nix-community")
    (mkCache "veloren-nix")
    (mkCache "osu-nix")
  ];
in {
  programs.fish = {
    enable = true;
    vendor.completions.enable = true;
  };

  age.secrets = {
    variables = {
      file = ./secrets/variables.age;
      owner = "nix";
      mode = "0700";
    };
    wpa = {
      file = ./secrets/wpa_supplicant.conf.age;
      mode = "0700";
    };
    steam = {
      file = ./secrets/steam.age;
      owner = "nix";
      mode = "0700";
    };
  };

  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  environment = {
    sessionVariables = {
      NIXOS_CONFIG = "/home/nix/dotnix";
      fish_greeting = "";
    };

    systemPackages = with pkgs; [ man-pages ];

    shellAliases = { nix-repl = "nix repl ${inputs.utils.lib.repl}"; };
  };

  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "dialout" "libvirtd" ];
    shell = pkgs.fish;
    # hello dear attackers, this is only a default password, and changed immediately after installation
    initialPassword = "nix";
  };

  nix = {
    systemFeatures = [
      "recursive-nix"
    ];

    extraOptions = lib.mkForce ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes ca-derivations recursive-nix
    '';

    # turn this off later!!!
    useSandbox = false;

    package = pkgs.nixUnstable;
    trustedUsers = [ "root" "nix" ];

    gc = {
      automatic = true;
      options = "--delete-older-than 7d";
      dates = "weekly";
    };

    binaryCaches = caches;

    binaryCachePublicKeys = [
      "lom.cachix.org-1:R0BYXkgRm24m+gHUlYzrI2DxwNEOKWXF1/VdYSPCXyQ="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "neovim-nightly.cachix.org-1:feIoInHRevVEplgdZvQDjhp11kYASYCE2NGY9hNrwxY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "veloren-nix.cachix.org-1:zokfKJqVsNV6kI/oJdLF6TYBdNPYGSb+diMVQPn/5Rc="
      "osu-nix.cachix.org-1:vn/szRSrx1j0IA/oqLAokr/kktKQzsDgDPQzkLFR9Cg="
    ];

    nixPath = [ "nixpkgs=${pkgs.path}" "home-manager=${inputs.home-manager}" ];

    trustedBinaryCaches = caches;
  };

  programs.command-not-found.enable = false;

  time.timeZone = "America/Guatemala";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  programs.cowsay = {
    enable = true;
    cows.giraffe = ''
      $thoughts
       $thoughts
        $thoughts
           ^__^
           (oo)
           (__)
             \\ \\
              \\ \\
               \\ \\
                \\ \\
                 \\ \\
                  \\ \\
                   \\ \\
                    \\ \\______
                     \\       )\\/\\/\\
                      ||----w |
                      ||     ||
    '';
  };
}

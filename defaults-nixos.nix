{ pkgs, config, lib, inputs, ... }:

let
  mkCache = name: "https://${name}.cachix.org";

  caches = [
    (mkCache "lom")
    "https://cache.nixos.org"
    #(mkCache "neovim-nightly")
    (mkCache "nix-community")
    (mkCache "veloren-nix")
    (mkCache "nix-gaming")
  ];
  TZ = "America/Guatemala";
in {
  programs.fish = {
    enable = true;
    vendor = {
      completions.enable = true;
      config.enable = true;
      functions.enable = true;
    };
  };

  age.secrets = {
    variables = {
      file = ./secrets/variables.age;
      owner = "nix";
      mode = "0400";
    };
    steam = {
      file = ./secrets/steam.age;
      owner = "asf";
      mode = "0440";
    };
    steam-2 = {
      file = ./secrets/steam-2.age;
      owner = "asf";
      mode = "0440";
    };
    steam-3 = {
      file = ./secrets/steam-3.age;
      owner = "asf";
      mode = "0440";
    };
  };

  environment = {
    sessionVariables = {
      NIXOS_CONFIG = "/home/nix/dotnix";
      fish_greeting = "";
      DOTNET_CLI_TELEMETRY_OPTOUT = "1";
    };

    systemPackages = with pkgs; [ man-pages git ];

    defaultPackages = lib.mkForce [ ];
  };

  # print ip address before login prompt
  services.getty.helpLine = ''
    \4
  '';

  users.users.nix = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "dialout" "libvirtd" "asf" ];
    shell = pkgs.fish;
    description = "Default user, nothing interesting";
    # hello dear attackers, this is only a default password, and changed immediately after installation
    initialPassword = "nix";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIONNQcvhcUySNuuRKroWNAgSdcfy7aqO3UsezT/C/XAQ legendofmiracles@protonmail.com"
    ];
  };

  nix = {
    systemFeatures = [ "recursive-nix" "kvm" "nixos-test" "big-parallel" ];

    extraOptions = ''
      keep-outputs = true
      keep-derivations = true
      experimental-features = nix-command flakes
    '';

    # turn this off later!!!
    #useSandbox = false;

    package = pkgs.nixUnstable;
    trustedUsers = [ "root" "nix" ];

    gc = {
      automatic = false;
      options = "--delete-older-than 7d";
      dates = "weekly";
    };

    binaryCaches = caches;
    binaryCachePublicKeys = [
      "lom.cachix.org-1:R0BYXkgRm24m+gHUlYzrI2DxwNEOKWXF1/VdYSPCXyQ="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      #"neovim-nightly.cachix.org-1:feIoInHRevVEplgdZvQDjhp11kYASYCE2NGY9hNrwxY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "veloren-nix.cachix.org-1:zokfKJqVsNV6kI/oJdLF6TYBdNPYGSb+diMVQPn/5Rc="
      "nix-gaming.cachix.org-1:vn/szRSrx1j0IA/oqLAokr/kktKQzsDgDPQzkLFR9Cg="
    ];

    nixPath = [ "nixpkgs=${pkgs.path}" "home-manager=${inputs.home-manager}" ];

    trustedBinaryCaches = caches;

    generateRegistryFromInputs = true;

    linkInputs = true;
  };

  programs.command-not-found.enable = false;

  time.timeZone = TZ;

  environment.variables = { inherit TZ; };

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.supportedLocales = [ "en_US.UTF-8/UTF-8" ];

  services.journald.extraConfig = "SystemMaxUse=50M";

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "googleearth-pro-7.3.4.8248"
    ];
  };

  documentation = {
    nixos.enable = false;
    info.enable = false;
  };

  networking.hosts = {
    # https://www.scss.tcd.ie/Doug.Leith/pubs/browser_privacy.pdf
    "0.0.0.0" = [
      "incoming.telemetry.mozilla.org"
      "push.services.mozilla.com"
      "safebrowsing.googleapis.com"
    ];
  };
}

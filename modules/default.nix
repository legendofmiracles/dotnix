inputs: {
  cowsay = import ./cowsay.nix inputs;
  discord-message-sender = import ./discord-message-sender.nix inputs;
  minecraft = import ./minecraft.nix inputs;
  espanso-m = import ./espanso-m.nix inputs;
}

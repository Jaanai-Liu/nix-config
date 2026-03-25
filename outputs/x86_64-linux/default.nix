# outputs/x86_64-linux/default.nix
args: {
  "lz-pc" = import ./lz-pc.nix args;
  "lz-laptop" = import ./lz-laptop.nix args;
  "lz-vps" = import ./lz-vps.nix args;
}

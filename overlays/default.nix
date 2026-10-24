{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./tools.nix
    ./packages.nix
    ./nurs.nix
    ./udiskie.nix
    ./mozc.nix
    ./fcitx5
  ];
}

# Symlink the laptop-specific env.kdl to override the shared empty default.
{
  config,
  lib,
  ...
}:
{
  xdg.configFile."niri/env.kdl".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/hosts/lz-nb/niri/env.kdl"
  );
}

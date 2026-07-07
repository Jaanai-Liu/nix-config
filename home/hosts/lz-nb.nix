{
  config,
  pkgs,
  myvars,
  lib,
  ...
}:

{
  imports = [
    ../../home
  ];

  home.desktop.niri.enable = true;
  home.tui.mail.enable = true;

  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  xdg.configFile."niri/output.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/hosts/lz-nb/niri/output.kdl";

  # Override shared env.kdl with laptop-specific XWayland scaling vars.
  xdg.configFile."niri/env.kdl".source = lib.mkForce (
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/hosts/lz-nb/niri/env.kdl"
  );

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}

{
  config,
  pkgs,
  myvars,
  ...
}:

{
  imports = [
    ../../home
    # ./niri
  ];

  home.desktop.niri.enable = true;
  home.tui.mail.enable = true;

  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  xdg.configFile."niri/output.kdl".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/hosts/lz-pc/niri/output.kdl";

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

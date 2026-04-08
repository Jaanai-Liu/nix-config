{
  config,
  pkgs,
  myvars,
  ...
}:

{
  imports = [
    ../../home
    ./niri
  ];

  modules.desktop.niri.enable = true;

  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  fonts.fontconfig.enable = true;

  home.stateVersion = "25.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

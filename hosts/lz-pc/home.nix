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

  # modules.synopsys.enable = true;

  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [

  ];

  home.stateVersion = "25.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

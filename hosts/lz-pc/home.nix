
{ config, pkgs, myvars, ... }:

{
  imports = [
    ../../home
    ./niri
  ];
  # 注意修改这里的用户名与用户目录
  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  fonts.fontconfig.enable = true;
  home.packages = with pkgs;[

  ];

  home.stateVersion = "25.11";
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

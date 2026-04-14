# hosts/lz-vps/home.nix
{ myvars, pkgs, ... }:

{
  programs.home-manager.enable = true;
  home.username = myvars.username;
  home.homeDirectory = "/home/${myvars.username}";

  home.packages = with pkgs; [
    htop
  ];

  home.stateVersion = "25.11";

  imports = [
    ../../home/base
    ../../home/tui
  ];
}

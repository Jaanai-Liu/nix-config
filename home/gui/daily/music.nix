{ pkgs, ... }:
{
  home.packages = with pkgs; [
    splayer
  ];
}
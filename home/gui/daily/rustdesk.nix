# home/gui/daily/rustdesk.nix
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    rustdesk-flutter
  ];
}

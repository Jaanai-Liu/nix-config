# home/gui/daily/screenshot.nix
{ pkgs, ... }:
{

  home.activation.createScreenshotDir = ''
    mkdir -p $HOME/Pictures/Screenshots
  '';

  home.packages = with pkgs; [
    grim
    slurp
    satty
    wl-clipboard
  ];
}


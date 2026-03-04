{ pkgs, ... }:
{
  # Enable the niri Desktop Environment.
  programs.niri.enable = true;
  programs.xwayland.enable = true;
  programs.dconf.enable = true;
}

{ config, pkgs, ... }:

{
  # environment.systemPackages = with pkgs; [
  #   throne
  # ];
  programs.throne = {
    enable = true;
    tunMode.enable = true;
  };
}

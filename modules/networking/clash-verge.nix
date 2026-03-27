{ pkgs, ... }:
{
  # Clash
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    # package = pkgs.clash-verge-rev;
    serviceMode = true;
    tunMode = true;
  };
}

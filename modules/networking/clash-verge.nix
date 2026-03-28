{
  pkgs,
  pkgs-unstable,
  inputs,
  ...
}:
{
  # Clash
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    package = pkgs-unstable.clash-verge-rev;
    serviceMode = true;
    tunMode = true;
  };
}

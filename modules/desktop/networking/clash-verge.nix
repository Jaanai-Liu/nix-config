{
  pkgs,
  pkgs-stable,
  inputs,
  ...
}:
{
  # Clash
  programs.clash-verge = {
    enable = true;
    autoStart = false;
    serviceMode = true;
    tunMode = true;
  };
}

{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    # GDK_BACKEND = "wayland,x11";
    ANKI_WAYLAND = "1";
  };
}

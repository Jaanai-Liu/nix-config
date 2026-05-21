{ config, pkgs, ... }:
{
  environment.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    # NIXOS_OZONE_WL removed: was injecting deprecated Electron flags into VSCode wrapper.
    # Use ELECTRON_OZONE_PLATFORM_HINT instead — the native Electron Wayland mechanism.
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
    # GDK_BACKEND = "wayland,x11";
    ANKI_WAYLAND = "1";
  };
}

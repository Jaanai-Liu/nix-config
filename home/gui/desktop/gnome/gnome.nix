{ config, pkgs, ... }:

{
  home.packages = with pkgs;[
    # gnome Extension
    # gnome-extensions-app
    gnome-extension-manager
    gnomeExtensions.gsconnect
    gnomeExtensions.appindicator
    # gnomeExtensions.kimpanel
    gnomeExtensions.clipboard-indicator
  ];
}

{ pkgs, lib, ... }:
let
  yazi-wrapper = pkgs.writeShellScript "yazi-wrapper" ''
    #!/usr/bin/env bash
    out_path="$3"
    start_dir="$2"
    ${pkgs.kitty}/bin/kitty --class "yazi-picker" -e ${pkgs.yazi}/bin/yazi --chooser-file="$out_path" "$start_dir"
  '';
in
{
  environment.etc."xdg/xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${yazi-wrapper}
  '';

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-termfilechooser
      xdg-desktop-portal-gnome
    ];

    config = {
      common = {
        default = [ "gtk" ];
      };

      niri = {
        # default = lib.mkForce [ "gtk" ];
        default = lib.mkForce [ "termfilechooser" ];
        "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
        "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
      };
    };
  };
}

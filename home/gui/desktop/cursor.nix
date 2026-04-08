# home/tui/cursor.nix
{ pkgs, ... }:
let
  cursorSize = 12;
  cursorName = "Bibata-Modern-Ice";
  # cursorName = "Adwaita";
in
{
  home.pointerCursor = {
    package = pkgs.bibata-cursors;
    # package = pkgs.adwaita-icon-theme;
    name = cursorName;
    size = cursorSize;
    gtk.enable = true;
    x11.enable = true;
  };

  home.sessionVariables = {
    XCURSOR_SIZE = toString cursorSize;
    XCURSOR_THEME = cursorName;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      package = pkgs.bibata-cursors;
      name = cursorName;
      size = cursorSize;
    };
  };

  gtk.gtk4.theme = null;
}

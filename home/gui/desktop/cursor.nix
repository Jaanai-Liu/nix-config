# home/tui/cursor.nix
#
# Cursor theme & size for the whole desktop (Wayland + X11 + GTK).
# Switch between "default" (Adwaita) and custom (Bibata) by
# commenting/uncommenting the marked blocks.
{ pkgs, ... }:
let
  # ---- size ----
  cursorSize = 24; # 24 = minimum usable; common: 24, 32, 48

  # ---- theme (pick one) ----
  # Default: Adwaita (built into GNOME/GTK, no extra package needed)
  cursorName = "Adwaita";
  cursorPackage = pkgs.adwaita-icon-theme;

  # Custom: Bibata-Modern-Ice (uncomment to switch back)
  # cursorName = "Bibata-Modern-Ice";
  # cursorPackage = pkgs.bibata-cursors;
in
{
  home.pointerCursor = {
    package = cursorPackage;
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
      package = cursorPackage;
      name = cursorName;
      size = cursorSize;
    };
  };

  gtk.gtk4.theme = null;
}

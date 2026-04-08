{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.sessionVariables = {
    # GDK_BACKEND = "wayland,x11";
    ANKI_WAYLAND = "1";
    CLASH_VERGE_REWRITE_CONFIG = "true";

    IM_MODULE = "fcitx";
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };
}

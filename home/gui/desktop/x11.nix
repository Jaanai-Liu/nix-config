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
  };
}


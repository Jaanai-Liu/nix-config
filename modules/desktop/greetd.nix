{
  pkgs,
  myvars,
  lib,
  ...
}:
{
  security.pam.services.greetd.enableGnomeKeyring = true;
  services.displayManager.gdm.enable = false;

  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       user = myvars.username;
  #       command = "$HOME/.wayland-session";
  #       # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session";  # start wayland session with a TUI login manager
  #     };
  #   };
  # };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        # user = "greeter";
        user = myvars.username;

        # command = "/home/${myvars.username}/.wayland-session";
        command = lib.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--remember"
          "--remember-session"
          "--asterisks"
          "--user-menu"
          "--cmd /home/${myvars.username}/.wayland-session"
          "--theme 'border=magenta;text=cyan;prompt=green;time=yellow'"
        ];
        # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session"; # start wayland session with a TUI login manager
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}

{ pkgs, myvars, lib, ... }: {
  
  # 1. 开启 Gnome Keyring (非常重要，否则你每次开 Chrome 都要输密码)
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.displayManager.gdm.enable = false;


  # services.greetd = {
  #   enable = true;
  #   settings = {
  #     default_session = {
  #       user = "zheng"; 
  #       command = "$HOME/.wayland-session";
  #       # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session";  # start wayland session with a TUI login manager
  #     };
  #   };
  # };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "greeter"; 
        # 加上--remember(记住上次登录)和--asterisks(密码显示星号)
        command = lib.concatStringsSep " " [
          "${pkgs.tuigreet}/bin/tuigreet"
          "--time"
          "--remember"
          "--remember-session"
          "--asterisks" # 密码显示星号
          "--user-menu"
          "--cmd /home/zheng/.wayland-session"
          "--theme 'border=magenta;text=cyan;prompt=green;time=yellow'"
        ];
        # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd $HOME/.wayland-session";  # start wayland session with a TUI login manager
      };
    };
  };

  # 3. 【关键补丁】确保tuigreet能正常显示
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
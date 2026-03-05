{ pkgs, myvars, ... }: {
  
  # 1. 开启 Gnome Keyring (非常重要，否则你每次开 Chrome 都要输密码)
  security.pam.services.greetd.enableGnomeKeyring = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = "zheng"; 
        command = "$HOME/.wayland-session"; 
      };
    };
  };

  services.xserver.displayManager.gdm.enable = false;
}
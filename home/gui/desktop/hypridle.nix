{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    hypridle
  ];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "noctalia-shell ipc call lockScreen lock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };

      listener = [
        # 5分钟(300s)熄屏
        {
          # timeout = 300;
          # on-timeout = "niri msg action power-off-monitors";
          # on-resume = "niri msg action power-on-monitors";

          # timeout = 300;
          # on-timeout = "brightnessctl -s set 0";
          # on-resume = "brightnessctl -r";

        }
        # 10分钟(600s)锁屏
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        # 15分钟(900s)睡眠
        # {
        #   timeout = 900;
        #   on-timeout = "systemctl suspend";
        # }
      ];
    };
  };
}


{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    hypridle
  ];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "noctalia msg session lock";
        # before_sleep_cmd = "loginctl lock-session";
        before_sleep_cmd = "noctalia msg session lock";
        after_sleep_cmd = "niri msg action power-on-monitors";
      };

      listener = [
        # 5 mins (300s) poweroff monitors
        {
          timeout = 300;
          on-timeout = "niri msg action power-off-monitors";
          on-resume = "niri msg action power-on-monitors";

          # timeout = 300;
          # on-timeout = "brightnessctl -s set 0";
          # on-resume = "brightnessctl -r";

        }
        # 10 mins (600s) lock
        {
          timeout = 600;
          on-timeout = "loginctl lock-session";
        }
        # 15 mins (900s) sleep
        {
          timeout = 900;
          on-timeout = "systemctl suspend";
          # on-timeout = "systemctl hibernate";
        }
      ];
    };
  };
}

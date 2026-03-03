{ config, pkgs, lib, ... }:

{
  # ====================================================
  # 1. 核心包与字体
  # ====================================================
  home.packages = with pkgs; [
    mako swaybg swaylock grim slurp wl-clipboard brightnessctl
    swww waybar fuzzel kitty
    nerd-fonts.jetbrains-mono noto-fonts-cjk-sans
  ];

  # ====================================================
  # 2. Waybar 状态栏配置
  # ====================================================
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top"; position = "top"; height = 30;
      modules-left = [ "niri/window" ];
      modules-center = [ "clock" ];
      modules-right = [ "cpu" "memory" "network" "tray" ];
      "niri/window" = { format = "󰖲 {}"; };
      "clock" = {
        format = " {:%H:%M}";
        format-alt = "󰃭 {:%Y-%m-%d}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };
      "cpu" = { format = " {usage}%"; };
      "memory" = { format = " {percentage}%"; };
      "network" = {
        format-wifi = " {essid}";
        format-ethernet = "󰈀 eth";
        format-disconnected = "󰖪 off";
      };
    }];
    style = ''
      * { font-family: "JetBrainsMono Nerd Font", "Noto Sans CJK SC", sans-serif; font-size: 14px; border: none; border-radius: 0; }
      window#waybar { background: rgba(43, 48, 59, 0.5); color: #ffffff; border-bottom: 2px solid rgba(100, 114, 125, 0.5); }
      #clock, #cpu, #memory, #network, #window { padding: 0 10px; margin: 0 5px; }
      #clock { color: #64f1f1; }
      #cpu { color: #fb8c00; }
    '';
  };

  # ====================================================
  # 3. Fuzzel 启动器配置
  # ====================================================
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        font = "JetBrainsMono Nerd Font:size=14";
        prompt = "󰍉 ";
      };
      colors = {
        background = "282a36b3";
	text = "f8f8f2ff";
	match = "8be9fdff";
        selection = "44475aff";
	selection-text = "8be9fdff";
	border = "bd93f9ff";
      };
    };
  };

  programs.kitty = {
    enable = true;
    settings = {
      background_opacity = lib.mkForce "0.6";
      background_blur = 1;
      font_family = "JetBrainsMono Nerd Font";
      font_size = "13.0";
      hide_window_decorations = "yes";
      window_padding_width = 10;
    };
  };

  # ====================================================
  # 4. Niri 核心配置 (防弹语法格式)
  # ====================================================
  xdg.configFile."niri/config.kdl".text = ''
    spawn-at-startup "${pkgs.swww}/bin/swww-daemon"
    spawn-at-startup "${pkgs.swww}/bin/swww" "img" "/etc/wallpapers/blood_marry.jpg" "--transition-type" "wipe"
    spawn-at-startup "${pkgs.waybar}/bin/waybar"

    input {
        keyboard {
            xkb {
                layout "us"
            }
        }
        touchpad {
            tap
            dwt
            natural-scroll
        }
        mouse {
            accel-profile "flat"
        }
    }

    output "DP-2" {
        // 开启最高刷新率
        mode "2560x1440@180.001"
        // 2K 分辨率在 27 寸左右的屏幕上 1.0 缩放是最完美的
        scale 1.0
        // 如果你需要旋转屏幕写代码，可以改成 "90" 或 "270"
        transform "normal"
        // 逻辑位置，单屏默认 0,0 即可
        position x=0 y=0
    }

    layout {
        gaps 16
        center-focused-column "never"
        preset-column-widths {
            proportion 0.33333
            proportion 0.5
            proportion 0.66667
        }
        default-column-width { proportion 0.5; }
        focus-ring {
            width 4
            active-color "#7fc8ff"
            inactive-color "#505050"
        }
    }

    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    animations { slowdown 1.0; }

    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }

    binds {
        Mod+Return { spawn "kitty"; }
        Alt+Space { spawn "fuzzel"; }
        Ctrl+Shift+L { spawn "swaylock"; }
        Mod+Shift+E { quit; }
        Mod+Q { close-window; }
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down; }
        Mod+Shift+K     { move-window-up; }
        Mod+Shift+L     { move-column-right; }
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+R { switch-preset-column-width; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C { center-column; }
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
        XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "set" "10%+"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "10%-"; }
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }
    }
  '';
}

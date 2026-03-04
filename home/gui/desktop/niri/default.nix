{ config, pkgs, lib, mylib, ... }:

{
  imports = mylib.scanPaths ./.;

  # ====================================================
  # 1. 核心包与字体
  # ====================================================
  home.packages = with pkgs; [
    mako swaybg swaylock-effects grim slurp wl-clipboard brightnessctl
    swww waybar fuzzel kitty
    nerd-fonts.jetbrains-mono noto-fonts-cjk-sans
    wlogout
    xwayland-satellite
  ];


  # ====================================================
  # Swaylock 深度美化配置
  # ====================================================
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;
    settings = {
      # 基础设置
      screenshots = true;
      clock = true;
      indicator = true;
      indicator-radius = 100;
      indicator-thickness = 7;
      
      # 关键：背景模糊效果 (非常适合你的透明桌面)
      effect-blur = "7x5";
      effect-vignette = "0.5:0.5";
      
      # 颜色配置 (深色通透风)
      color = "1a1b26";
      bs-hl-color = "bb9af7";
      key-hl-color = "7dcfff";
      
      # 环形指示器颜色
      ring-color = "414868";
      inside-color = "1a1b2688"; # 带透明度的内部
      separator-color = "00000000";
      
      # 验证状态颜色
      ring-ver-color = "7dcfff";
      inside-ver-color = "1a1b26";
      ring-wrong-color = "f7768e";
      inside-wrong-color = "1a1b26";
    };
  };

  # ====================================================
  # 2. Waybar 状态栏配置
  # ====================================================
  #programs.waybar = {
  #  enable = true;
  #  systemd.enable = true;
  #  settings = [{
  #    layer = "top"; position = "top"; height = 30;
  #    modules-left = [ "niri/window" ];
  #    modules-center = [ "clock" ];
  #    modules-right = [ "cpu" "memory" "network" "tray" ];
  #    "niri/window" = { format = "󰖲 {}"; };
  #    "clock" = {
  #      format = " {:%H:%M}";
  #      format-alt = "󰃭 {:%Y-%m-%d}";
  #      tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
  #    };
  #    "cpu" = { format = " {usage}%"; };
  #    "memory" = { format = " {percentage}%"; };
  #    "network" = {
  #      format-wifi = " {essid}";
  #      format-ethernet = "󰈀 eth";
  #      format-disconnected = "󰖪 off";
  #    };
  #  }];
  #  style = ''
  #    * { font-family: "JetBrainsMono Nerd Font", "Noto Sans CJK SC", sans-serif; font-size: 14px; border: none; border-radius: 0; }
  #    window#waybar { background: rgba(43, 48, 59, 0.5); color: #ffffff; border-bottom: 2px solid rgba(100, 114, 125, 0.5); }
  #    #clock, #cpu, #memory, #network, #window { padding: 0 10px; margin: 0 5px; }
  #    #clock { color: #64f1f1; }
  #    #cpu { color: #fb8c00; }
  #  '';
  #};

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
    include "output.kdl"

    spawn-at-startup "sh" "-c" "${pkgs.swww}/bin/swww-daemon"
    spawn-at-startup "sh" "-c" "${pkgs.swww}/bin/swww" "img" "/etc/wallpapers/meihua.JPG" "--transition-type" "wipe"
    // spawn-at-startup "${pkgs.waybar}/bin/waybar"
    spawn-at-startup "noctalia-shell"
    // spawn-at-startup "sh" "-c" "WEBKIT_DISABLE_DMABUF_RENDERER=1 WEBKIT_DISABLE_COMPOSITING_MODE=1 GDK_BACKEND=wayland clash-verge"
    spawn-at-startup "clash-verge"
    spawn-at-startup "xwayland-satellite"

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
            width 0
        }
        border {
            width 1      // 边框粗细
            active-color "#7fc8ff22"   // 聚焦时的亮蓝色边框
            inactive-color "#50505011" // 闲置时的灰色边框
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
        // --- 1. 应用启动 ---
        Mod+Return { spawn "kitty"; }
        Alt+Space { spawn "fuzzel"; }
        Mod+L { spawn "swaylock" "-f"; }
        Mod+Shift+E { quit; }
        Mod+Q { close-window; }

        // --- 2. 桌面(Workspace)切换：上下键 ---
        Mod+Up          { focus-workspace-up; }
        Mod+Down        { focus-workspace-down; }
        Mod+Shift+Up    { move-column-to-workspace-up; }
        Mod+Shift+Down  { move-column-to-workspace-down; }
        Mod+Tab         { toggle-overview; }

        // --- 3. 窗口焦点切换 (保持 Vim 风格) ---
        Mod+Left  { focus-column-left; }
        Mod+Right { focus-column-right; }
        // Mod+H     { focus-column-left; }
        // Mod+L     { focus-column-right; }
        // Mod+J     { focus-window-down; }
        // Mod+K     { focus-window-up; }

        // --- 4. 窗口快速切换 (Alt+Tab) ---
        // 绑定为切换到上一个活跃窗口
        Alt+Tab { focus-window-previous; }

        // --- 5. 布局调整与“缩放预览” (重点) ---
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+R { switch-preset-column-width; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C { center-column; }
        
        // --- 6. 多媒体与截图 ---
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

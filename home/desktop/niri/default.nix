# modules/niri.nix
{ config, pkgs, lib, inputs, ... }:

{  
  # 补充安装必要的依赖
  home.packages = with pkgs; [
    # inputs.niri.packages.${pkgs.system}.niri
    # niri
    fuzzel
    waybar
    mako
    swaybg
    swaylock
    grim
    slurp
    wl-clipboard
    brightnessctl # 调节亮度用
    # wpctl # 调节音量用 (通常 pipewire 自带，不用显式安装)
  ];
  
  # config niri
  xdg.configFile."niri/config.kdl".text = ''
    // --- 输入设备 ---
    input {
        keyboard {
            xkb { layout "us"; }
        }
        touchpad {
            tap
            dwt
            natural-scroll
        }
        mouse {
            accel-profile "flat";
        }
    }

    // --- 外观设置 ---
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

    // --- 杂项 ---
    prefer-no-csd
    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    // --- 动画 ---
    animations {
        slowdown 1.0
    }

    // --- 窗口规则 ---
    window-rule {
        geometry-corner-radius 12
        clip-to-geometry true
    }

    // --- 快捷键 (Binds) ---
    binds {
        // (A) 应用启动
        Mod+Return { spawn "kitty"; }
        Alt+Space { spawn "fuzzel"; }
        Mod+L { spawn "swaylock"; }

        // (B) 核心操作 (保命键)
        Mod+Shift+E { quit; }
        Mod+Q { close-window; }

        // (C) 窗口焦点移动 (Vim 风格 + 方向键)
        Mod+Left  { focus-column-left; }
        Mod+Down  { focus-window-down; }
        Mod+Up    { focus-window-up; }
        Mod+Right { focus-column-right; }
        Mod+H     { focus-column-left; }
        Mod+J     { focus-window-down; }
        Mod+K     { focus-window-up; }
        Mod+L     { focus-column-right; }

        // (D) 窗口移动 (Shift)
        Mod+Shift+Left  { move-column-left; }
        Mod+Shift+Down  { move-window-down; }
        Mod+Shift+Up    { move-window-up; }
        Mod+Shift+Right { move-column-right; }
        Mod+Shift+H     { move-column-left; }
        Mod+Shift+J     { move-window-down; }
        Mod+Shift+K     { move-window-up; }
        Mod+Shift+L     { move-column-right; }

        // (E) 窗口调整
        Mod+Minus { set-column-width "-10%"; }
        Mod+Equal { set-column-width "+10%"; }
        Mod+R { switch-preset-column-width; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C { center-column; }

        // (F) 音量与亮度
        XF86AudioRaiseVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1+"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn "wpctl" "set-volume" "@DEFAULT_AUDIO_SINK@" "0.1-"; }
        XF86AudioMute        allow-when-locked=true { spawn "wpctl" "set-mute" "@DEFAULT_AUDIO_SINK@" "toggle"; }
        XF86MonBrightnessUp   allow-when-locked=true { spawn "brightnessctl" "set" "10%+"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "10%-"; }

        // (G) 截图
        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }
    }
  '';
}


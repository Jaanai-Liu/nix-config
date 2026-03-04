{
  pkgs,
  lib,
  ...
}:
{
  # ====================================================
  # 2. Waybar 状态栏配置
  # ====================================================
programs.waybar = {
    enable = false;
    systemd.enable = false;
    settings = [{
      layer = "top";
      position = "top";
      height = 35;
      # 开启排他性，确保窗口不会遮挡状态栏，点击更灵敏
      exclusive = true;

      # ====================================================
      # 模块布局
      # ====================================================
      modules-left = [ "niri/workspaces" "niri/window" ];
      modules-center = [ "clock" ];
      modules-right = [ 
        "backlight" 
        "pulseaudio" 
        "network" 
        "bluetooth" 
        "tray"
        "custom/power" 
      ];

      # ====================================================
      # 左侧模块：工作区与窗口名
      # ====================================================
      "niri/workspaces" = {
        format = "{icon}";
        format-icons = {
          "active" = "";
          "default" = "";
        };
      };

      "niri/window" = {
        format = "󰖲 {}";
        max-length = 30;
        separate-outputs = true;
      };

      # ====================================================
      # 中间模块：日期与时间同时显示
      # ====================================================
      "clock" = {
        # 格式：14:30 󰃭 2026-03-04
        format = " {:%H:%M  󰃭 %Y-%m-%d}";
        format-alt = " {:%H:%M:%S}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      # ====================================================
      # 右侧模块：硬件控制与系统菜单
      # ====================================================
      
      # 亮度控制 (针对 7840HS 核显)
      "backlight" = {
        device = "amdgpu_bl0";
        format = "{icon} {percent}%";
        format-icons = [ "" "" "" "" "" "" "" "" "" ];
        on-scroll-up = "brightnessctl set 5%+";
        on-scroll-down = "brightnessctl set 5%-";
      };

      # 声音控制
      "pulseaudio" = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 Muted";
        format-icons = {
          headphone = "";
          default = [ "" "" "" ];
        };
        on-click = "pavucontrol"; # 点击打开音量面板
      };

      # 网络控制
      "network" = {
        format-wifi = " {essid}";
        format-ethernet = "󰈀 eth";
        format-disconnected = "󰖪 off";
        tooltip-format = "{ifname} via {gwaddr}";
        on-click = "nm-connection-editor"; # 点击打开网络设置
      };

      # 蓝牙模块
      "bluetooth" = {
        format = " {status}";
        format-disabled = "󰂲 off";
        format-connected = " {num_connections}";
        tooltip-format = "{controller_alias}\t{controller_address}";
        tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
        on-click = "blueman-manager"; # 点击打开蓝牙管理
      };

      # 电源菜单 (调用 Fuzzel 实现关机重启菜单)
      "custom/power" = {
        format = "";
        tooltip = false;
        on-click = "sh -c 'echo -e \"󰜉 重启\\n󰐥 关机\\n󰤄 睡眠\\n󰈆 注销\" | fuzzel --dmenu | xargs -I{} sh -c \"case {} in *重启) reboot;; *关机) shutdown now;; *睡眠) systemctl suspend;; *注销) niri msg action quit;; esac\"'";
      };

      "tray" = {
        icon-size = 18;
        spacing = 10;
      };
    }];

    # ====================================================
    # 样式美化 (CSS)
    # ====================================================
    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font", "Noto Sans CJK SC", sans-serif;
        font-size: 14px;
        border: none;
        border-radius: 0;
      }
      
      window#waybar {
        background: rgba(26, 27, 38, 0.6); /* 稍微加深一点，配合你的 0.6 透明度 Kitty */
        color: #ffffff;
        border-bottom: 2px solid rgba(127, 200, 255, 0.3); /* 使用你最喜欢的蓝色边框线 */
      }

      /* 模块间距 */
      #workspaces, #window, #clock, #backlight, #pulseaudio, #network, #bluetooth, #tray, #custom-power {
        padding: 0 12px;
        margin: 0 4px;
      }

      /* 各个模块的色彩点缀 */
      #workspaces button.active {
        color: #7fc8ff;
      }
      
      "clock" = {
        interval = 1;
        format = "󰃭 {:%Y-%m-%d   %H:%M:%S}";
        tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
      };

      #backlight { color: #e9ad0c; }
      #pulseaudio { color: #bb9af7; }
      #network { color: #9ece6a; }
      #bluetooth { color: #7aa2f7; }
      
      "custom/power" = {
        format = "";
        tooltip = false;
        on-click = "wlogout -b 4"; # 这里的4代表一行显示4个按钮
      };

      #tray {
        margin-left: 10px;
      }
    '';
  };
}
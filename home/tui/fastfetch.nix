# fastfetch.nix
{ pkgs, ... }:

{
  programs.fastfetch = {
    enable = true;
    settings = {
      # === Logo 设置 ===
      # 如果你的终端支持图片，可以尝试改为 type = "kitty"; source = "/你的/图片/路径.png";
      logo = {
        source = "nixos";
        padding = {
          top = 1;
          left = 2;
          right = 2;
        };
      };

      # === 全局显示设置 ===
      display = {
        separator = " "; # 键值对之间的分隔符为空格
        color = {
          title = "#bfc9c3";
          output = "#bfc9c3";
        };
      };

      # === 模块与布局设置 ===
      modules = [
        "break"

        # --- 第一块：系统层 (薄荷绿) ---
        {
          type = "os";
          key = "OS";
          keyColor = "#88d6bb";
        }
        {
          type = "kernel";
          key = " ├   KER ";
          keyColor = "#88d6bb";
        }
        {
          type = "packages";
          key = " ├   PAK ";
          keyColor = "#88d6bb";
          format = "{all}";
        }
        {
          type = "title";
          key = " └   USR ";
          keyColor = "#88d6bb";
        }
        "break"
        "break"

        # --- 第二块：环境层 (婴儿蓝) ---
        {
          type = "wm";
          key = "WM";
          keyColor = "#a8cbe2";
        }
        {
          type = "de";
          key = " ├ 󱈹  DES ";
          keyColor = "#a8cbe2";
        }
        {
          type = "shell";
          key = " ├   SHE ";
          keyColor = "#a8cbe2";
        }
        {
          type = "terminal";
          key = " ├   TER ";
          keyColor = "#a8cbe2";
        }
        {
          type = "terminalfont";
          key = " └   TFO ";
          keyColor = "#a8cbe2";
        }
        "break"
        "break"

        # --- 第三块：硬件层 (极光青) ---
        # 完美展示你的 12400F 和 AMD GPU
        {
          type = "host";
          key = "PC ";
          keyColor = "#cee9dd";
        }
        {
          type = "cpu";
          key = " ├   CPU ";
          keyColor = "#cee9dd";
        }
        {
          type = "memory";
          key = " ├   MEM ";
          keyColor = "#cee9dd";
        }
        {
          type = "gpu";
          key = " ├ 󰢮  GPU ";
          keyColor = "#cee9dd";
          format = "{1} {2}";
        }
        {
          type = "display";
          key = " ├   MON ";
          keyColor = "#cee9dd";
          format = "{name} {width}x{height}@{refresh-rate} ";
        }
        {
          type = "disk";
          key = " └ 󰋊  DIS ";
          keyColor = "#cee9dd";
        }
        "break"
        "break"

        # --- 底部颜色条 ---
        "colors"
      ];
    };
  };
}

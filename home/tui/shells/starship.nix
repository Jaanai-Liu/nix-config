{
  config,
  pkgs,
  lib,
  ...
}:
{
  programs.starship = {
    enable = true;

    enableZshIntegration = true;

    settings = {
      # 1. 核心格式：解决了你看到的“空箭头”问题
      format = lib.concatStrings [
        "[](color_first)"
        "$os"
        "$username"
        "[](bg:color_yellow fg:color_first)"
        "$directory"
        "[](fg:color_yellow bg:color_aqua)"
        "$git_branch"
        "$git_status"
        "[](fg:color_aqua bg:color_purple)" # 这一块放开发语言
        "$c$rust$python$nix_shell"
        "[](fg:color_purple bg:color_bg3)"
        "$conda"
        "[](fg:color_bg3 bg:color_bg1)"
        "$time"
        "[ ](fg:color_bg1)"
        "$line_break"
        "$character"
      ];

      # 2. 颜色面板：Catppuccin Mocha 调色盘
      palette = "catppuccin_mocha";
      palettes.catppuccin_mocha = {
        color_first = "#cba6f7";   # 薰衣草紫，和雪花蓝是对比色
        color_yellow = "#f9e2af";  # 黄色 (路径)
        color_aqua = "#94e2d5";    # 青色 (Git)
        color_purple = "#cba6f7";  # 薰衣草紫 (语言/Nix)
        color_bg3 = "#585b70";     # 深灰 (Conda)
        color_bg1 = "#313244";     # 更深灰 (时间)
        color_fg0 = "#11111b";     # 极深色 (文字)
        color_fg1 = "#cdd6f4";     # 浅灰色 (时间文字)
        color_green = "#a6e3a1";   # 成功绿
        color_red = "#f38ba8";     # 失败红
      };

      # 3. 模块细调
      os = {
        disabled = false;
        style = "bg:color_first fg:color_fg0";
        symbols.NixOS = "❄️ ";
      };

      username = {
        show_always = true;
        style_user = "bg:color_first fg:color_fg0";
        format = "[ $user ]($style)";
      };

      directory = {
        style = "fg:color_fg0 bg:color_yellow";
        format = "[ $path ]($style)";
        truncation_length = 3;
      };

      git_branch = {
        symbol = "";
        style = "bg:color_aqua";
        format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
      };

      # 给芯片工程师常用的语言加上显示
      python = {
        symbol = "🐍";
        style = "bg:color_purple";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_purple)]($style)";
      };
      c = {
        symbol = " ";
        style = "bg:color_purple";
        format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_purple)]($style)";
      };
      nix_shell = {
        symbol = "❄️ ";
        style = "bg:color_purple";
        format = "[[ $symbol ](fg:color_fg0 bg:color_purple)]($style)";
      };

      conda = {
        ignore_base = false;
        style = "bg:color_bg3";
        format = "[[  $environment ](fg:color_fg1 bg:color_bg3)]($style)";
      };

      time = {
        disabled = false;
        style = "bg:color_bg1";
        format = "[[  $time ](fg:color_fg1 bg:color_bg1)]($style)";
      };

      character = {
        success_symbol = "[](bold fg:color_green)";
        error_symbol = "[](bold fg:color_red)";
      };
    };
  };
}
{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    source-code-pro
    papirus-icon-theme
  ];

  programs.kitty = {
    enable = true;
    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };
    keybindings = {
      "ctrl+shift+m" = "toggle_maximized";
      "ctrl+shift+f" = "show_scrollback";
    };
    settings = {
      hide_window_decorations = "yes";
      background_opacity = "0.50";
      active_background_opacity = "0.50";
      inactive_background_opacity = "0.50";
      background_blur = 1;
      enable_audio_bell = false;
      tab_bar_edge = "top";
      # 保持你那个无敌的Shell启动逻辑，确保 Zsh 环境变量不丢
      shell = "${pkgs.bash}/bin/bash --login -c '${pkgs.zsh}/bin/zsh --login --interactive'";

      scrollback_lines = 10000;
      update_check_interval = 0;
      allow_remote_control = "yes";
      listen_on = "unix:/tmp/kitty";

      foreground = "#eff0eb";
      # background = "#282a36";
      color0 = "#282a36";
      color8 = "#767676";
      color1 = "#ff5c57";
      color9 = "#ff2400";
      color2 = "#5af78e";
      color10 = "#23fd00";
      color3 = "#f3f99d";
      color11 = "#fdff00";
      color4 = "#57c7ff";
      color12 = "#007fff";
      color5 = "#ff6ac1";
      color13 = "#ff1493";
      color6 = "#9aedfe";
      color14 = "#14ffff";
      color7 = "#f1f1f0";
      color15 = "#fffafa";

      # 1. 开启光标尾迹动画（核心！）
      cursor_trail = 3;
      # 尾迹衰减速度（0.1到1之间，数值越小越丝滑）
      cursor_trail_decay = "0.1 0.4";
      cursor_trail_start_threshold = 2;

      cursor_shape = "block";
      cursor_blink_interval = 0; # 建议关闭闪烁，让平滑移动更明显

      dynamic_background_opacity = "yes";
      linux_display_server = "wayland";
    };
  };
  xdg.desktopEntries.kitty = {
    name = "kitty";
    genericName = "Terminal emulator";
    exec = "kitty";
    icon = "${pkgs.papirus-icon-theme}/share/icons/Papirus/48x48/apps/utilities-terminal.svg";
    terminal = false;
    categories = [
      "System"
      "TerminalEmulator"
    ];
  };
}

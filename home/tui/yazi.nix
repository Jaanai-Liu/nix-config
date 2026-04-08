# home/tui/yazi.nix
{ pkgs, ... }:
{
  # ==========================================
  # 🌟 Yazi 本体配置
  # ==========================================
  programs.yazi = {
    enable = true;
    package = pkgs.yazi;
    # Changing working directory when exiting Yazi
    enableBashIntegration = true;
    enableNushellIntegration = true;
    shellWrapperName = "yy";
    settings = {
      mgr = {
        show_hidden = true;
        sort_dir_first = true;
      };
    };
  };

  # ==========================================
  # 🌟 创建桌面启动项 (等同于写 .desktop 文件)
  # ==========================================
  xdg.desktopEntries.yazi-folder = {
    name = "Yazi";
    comment = "Terminal file manager";
    icon = "system-file-manager";

    # exec = "kitty yazi %u";
    exec = "${pkgs.kitty}/bin/kitty ${pkgs.yazi}/bin/yazi %U";

    categories = [
      "System"
      "FileTools"
      "FileManager"
      "ConsoleOnly"
    ];
    mimeType = [ "inode/directory" ];
  };

  # ==========================================
  # 🌟 绑定为系统默认文件夹管理器
  # ==========================================
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "yazi-folder.desktop" ];
    };
  };
}

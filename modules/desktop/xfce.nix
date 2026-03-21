{ config, pkgs, ... }:

{
  # ==========================================
  # 🐭 XFCE 桌面环境配置
  # ==========================================

  # 确保 X11 基础服务已开启
  services.xserver.enable = true;

  # 启用 XFCE 桌面管理器
  services.xserver.desktopManager.xfce.enable = true;

  # 可选：安装一些常用的 XFCE 附加组件（如截图工具、任务管理器等）
  environment.systemPackages = with pkgs.xfce; [
    xfce4-taskmanager
    xfce4-screenshooter
  ];
}

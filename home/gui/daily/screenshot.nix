# home/gui/daily/screenshot.nix
{ pkgs, ... }: {
  
  # 确保你截图保存的默认目录存在
  home.activation.createScreenshotDir = ''
    mkdir -p $HOME/Pictures/Screenshots
  '';

  # 安装 Wayland 原生截图与贴图工具链
  home.packages = with pkgs; [
    grim          # 核心截图工具（负责抓取屏幕像素）
    slurp         # 屏幕框选工具（提供十字准星和区域选择）
    satty         # 现代化的截图编辑、标注与贴图工具
    wl-clipboard  # Wayland 剪贴板支持（让截图能直接 Ctrl+V 粘贴）
  ];
}
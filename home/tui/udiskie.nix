# modules/home/tui/udiskie.nix
{ ... }: {
  services.udiskie = {
    enable = true;
    # 由于你没有常规状态栏，tray 设为 auto 或 never
    tray = "auto"; 
    # 启用通知（如果你有 mako 或 dunst 之类的通知服务，插拔时会有弹窗）
    notify = true;
  };
}
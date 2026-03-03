{ config, pkgs, myvars, ... }:
{
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      # 允许 X11 图形界面转发
      X11Forwarding = true;
    };
  };

  # 安装并允许 SSH 调用 xauth 工具
  programs.ssh.setXAuthLocation = true;
}
{ pkgs, config, lib, mylib, ... }:
let
  # 关键：定义你本地仓库的绝对路径，确保和你的主机名、用户名对应
  confPath = "${config.home.homeDirectory}/nixos-config/home/gui/desktop/niri/conf";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in
{
  # imports = mylib.scanPaths ./.;

  home.packages = with pkgs; [
    xwayland-satellite  # X11兼容层
    kdePackages.polkit-kde-agent-1 # 权限弹窗代理
  ];

  # 软链接niri配置
  xdg.configFile = {
    "niri/config.kdl".source = mkSymlink "${confPath}/config.kdl";
    "niri/keybindings.kdl".source = mkSymlink "${confPath}/keybindings.kdl";
    # "niri/noctalia-shell.kdl".source = mkSymlink "${confPath}/noctalia-shell.kdl";
    "niri/spawn-at-startup.kdl".source = mkSymlink "${confPath}/spawn-at-startup.kdl";
    "niri/windowrules.kdl".source = mkSymlink "${confPath}/windowrules.kdl";
  };

  # Systemd 用户服务：确保开机自动启动权限代理
  systemd.user.services.niri-flake-polkit = {
    Unit = {
      Description = "PolicyKit Authentication Agent provided by niri-config";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session-pre.target" ];
    };
    Install.WantedBy = [ "niri.service" ];
    Service = {
      Type = "simple";
      ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      Restart = "on-failure";
      RestartSec = 1;
      TimeoutStopSec = 10;
    };
  };

  # .wayland-session 脚本
  # 作为 Greetd 的入口，保证了合成器启动的纯净性
  home.file.".wayland-session" = {
    executable = true;
    text = ''
      #!/bin/sh
      # 尝试清理旧的会话
      systemctl --user is-active niri.service && systemctl --user stop niri.service
      # 启动正式的 niri 会话
      exec /run/current-system/sw/bin/niri-session
    '';
  };
}
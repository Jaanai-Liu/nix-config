{
  pkgs,
  inputs,
  myvars,
  lib,
  ...
}:
let
  noctalia-greeter-pkg = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # noctalia-greeter-pkg = pkgs.noctalia-greeter; # 等 nixpkgs 收录后可切换
in
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  security.pam.services.greetd.enableGnomeKeyring = true;
  services.displayManager.gdm.enable = false;
  services.gnome.gnome-keyring.enable = true;

  # Noctalia Greeter:greetd 的 Wayland 登录界面,替代原来的 TUI 自动登录
  # + fzf 会话菜单(见 greetd.nix.bak)。
  #
  # 流程:greetd 以 greeter 系统用户"自动登录"进 greeter 会话,登录界面
  # 里选用户/会话并输密码(PAM 认证),再交接给选中的桌面会话。因为密码
  # 在登录界面输入,pam_gnome_keyring 在会话启动时解锁 login keyring,
  # 开机不再弹 "Unlock keyring"。
  services.displayManager.noctalia-greeter = {
    enable = true;
    package = noctalia-greeter-pkg;
    # 允许 noctalia 守护进程免 polkit 弹窗把壁纸/配色同步到登录界面
    passwordless-sync-users = [ myvars.username ];
    settings = {
      user.default = myvars.username;
      session.default = "Niri";
      cursor.size = 24;
    };
  };

  # greeter 会话以 greetd 模块创建的 greeter 系统用户运行;
  # noctalia-greeter 模块读它做状态目录(/var/lib/noctalia-greeter)的属主
  services.greetd.settings.default_session.user = "greeter";
}

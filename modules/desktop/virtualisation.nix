{
  config,
  pkgs,
  myvars,
  ...
}:

{
  # ==========================================
  # 💻 KVM / QEMU 原生虚拟化配置
  # ==========================================

  # 1. 启用 libvirtd (KVM 的后台管理守护进程)
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true; # 方便处理一些网络和共享目录的权限
      swtpm.enable = true; # 支持 TPM 2.0 (装 Win11 可能会用到，顺手开启)
    };
  };

  # 2. 启用 virt-manager (强大的图形化虚拟机管理工具)
  programs.virt-manager.enable = true;

  # 3. 必须开启 dconf (virt-manager 需要它来保存图形界面的偏好设置)
  programs.dconf.enable = true;

  # 4. 把你的当前用户加入 libvirtd 用户组 (极其重要，否则打不开虚拟机)
  # 假设你的用户名变量是 myvars.username，如果不是，请直接写 "zheng"
  users.users.${myvars.username}.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  # 5. 可选：安装一些虚拟机相关的网络和文件共享辅助工具
  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    linux-firmware # 确保网卡等固件齐全
  ];
}

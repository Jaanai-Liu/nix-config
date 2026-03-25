# hosts/lz-vps/default.nix
{
  config,
  pkgs,
  modulesPath,
  ...
}:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix") # 专门给 KVM 虚拟机的驱动
    ./disk-config.nix # 引入刚才的硬盘规划
  ];

  # 引导程序配置 (兼容双模式)
  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "/dev/vda";
  };

  # 基础网络与时间
  networking.hostName = "lz-vps";
  time.timeZone = "Asia/Shanghai";

  # 🌟 救命神器：开启 1GB 的 ZRAM 内存压缩，代替硬盘 Swap，让你的 VPS 飞起来
  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;

  # BBR 网络加速
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  # 必要的系统包
  environment.systemPackages = with pkgs; [
    wget
    curl
    git
  ];

  # 🌟【必须要改这里！】填入你台式机的 SSH 公钥
  # 如果你不知道公钥是什么，可以在台式机的终端里运行 `cat ~/.ssh/id_ed25519.pub` 或 `cat ~/.ssh/id_rsa.pub`
  users.users.root = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL8B31wZficBJy4Tli3w+C0hsa7uhsMlff43JF6PSYBe liujaanai@gmail.com"
    ];
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
    settings.PasswordAuthentication = false;
  };

  system.stateVersion = "25.11";
}

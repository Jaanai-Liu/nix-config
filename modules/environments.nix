{
  pkgs,
  config,
  inputs,
  ...
}:
{
  # 👇 定义一个 Overlay，把 unstable 的包打包放到 pkgs.unstable 下面
  # nixpkgs.overlays = [
  #  (final: prev: {
  #   unstable = import inputs.nixpkgs-unstable {
  #     system = prev.system;
  #     config.allowUnfree = true;
  #    };
  #  })
  #];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fastfetch
    # vim-full
    neovim
    tmux
    wget
    git

    # system monitoring
    btop
    # htop

    tree

    # archives
    zip
    xz
    zstd
    unzipNLS
    p7zip

    # system tools
    psmisc # killall/pstree/prtstat/fuser/...
    lm_sensors # for `sensors` command
    pciutils # lspci
    usbutils # lsusb
    parted

    # fuse

    strace # 调试检查缺了什么strace snipaste 2>&1 | grep -iE "error|no such file"

  ];

  # BCC - Tools for BPF-based Linux IO analysis, networking, monitoring, and more
  # https://github.com/iovisor/bcc
  # programs.bcc.enable = true;

  environment.variables.EDITOR = "neovim";

  programs.dconf.enable = true;
}

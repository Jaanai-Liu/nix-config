{ config, pkgs, ... }:

{
  # 开启 nix-ld，让传统 Linux 动态链接程序在 NixOS 上直接运行
  programs.nix-ld.enable = true;

  # 这里包含了 Synopsys (lmgrd, snpslmd, VCS, Verdi) 运行所需的所有核心依赖
  programs.nix-ld.libraries = with pkgs; [
    # --- 基础 C/C++ 运行库 ---
    stdenv.cc.cc # 提供 libstdc++.so.6
    glibc # 提供 libc.so.6, libm.so.6 等
    zlib # 提供 libz.so.1

    # --- 授权服务 (FlexLM) 强依赖 ---
    libxcrypt-legacy # 提供 libcrypt.so.1 (极其关键，旧版 lmgrd 常需密码学库)
    e2fsprogs # 提供 libuuid.so.1

    # --- GUI 界面 (Verdi / DVE) 依赖的 X11 图形库 ---
    xorg.libX11
    xorg.libXext
    xorg.libXrender
    xorg.libXrandr
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXi
    xorg.libSM
    xorg.libICE
    xorg.libXt
    xorg.libXmu
    xorg.libXp
    xorg.libXtst
    xorg.libXScrnSaver
    xorg.libXft

    # 2024 依赖
    libxml2
    xorg.xcbutil
    xorg.xcbutilwm
    xorg.xcbutilimage
    xorg.xcbutilkeysyms
    xorg.xcbutilrenderutil

    # --- 老旧软件常见多媒体与字体库 ---
    libpng12 # 旧版软件 UI 必备的古董图片库
    ncurses5 # 终端交互界面必备
    freetype
    libGL
    alsa-lib
    dbus
    fontconfig
    expat
    util-linux

    numactl # 解决 libnuma.so.1 (当前报错)
    libjpeg # 某些 UI 资源需要
    libtiff # 某些 UI 资源需要
    xorg.libXp # 老旧 X11 打印库
    libglvnd # 现代 OpenGL 支持
  ];

  systemd.tmpfiles.rules = [
    "L+ /lib64/ld-lsb-x86-64.so.3 - - - - /lib64/ld-linux-x86-64.so.2"
  ];

  # systemd.services.synopsys-license = {
  #   description = "Synopsys License Server (lmgrd)";
  #   wantedBy = [ "multi-user.target" ];
  #   after = [ "network.target" ];
  #   serviceConfig = {
  #     Type = "simple";
  #     User = myvars.username;
  #     # -z 参数的意思是前台运行，正好配合 systemd 的后台管理
  #     ExecStart = "/opt/synopsys/scl/2024.06/linux64/bin/lmgrd -c /opt/synopsys/scl/2024.06/admin/license/Synopsys.dat -z";
  #     Restart = "always"; # 就算意外崩溃也会自动复活
  #   };
  # };
}

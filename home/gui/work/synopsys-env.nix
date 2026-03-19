{
  config,
  lib,
  pkgs,
  ...
}:

let
  # 🌟 统一管理基础路径，改版本只需改这里
  synopsysHome = "/opt/synopsys";

  vcsHome = "${synopsysHome}/vcs/W-2024.09-SP1";
  verdiHome = "${synopsysHome}/verdi/W-2024.09-SP1";
  sclHome = "${synopsysHome}/scl/2024.06";
in
{
  # ==========================================
  # 🌟 Synopsys 2024 核心环境变量
  # ==========================================
  home.sessionVariables = {
    # 告诉 FHS 环境静态文件的物理位置
    XILINX_STATIC_HOME = "/opt/Xilinx";
    VC_STATIC_HOME = synopsysHome;

    # EDA 软件自身认的路径变量
    VCS_HOME = vcsHome;
    VERDI_HOME = verdiHome;
    SCL_HOME = sclHome;

    # PLI 动态库路径 (为了 Verdi 能够顺利抓取 VCS 的波形)
    LD_LIBRARY_PATH = "${verdiHome}/share/PLI/VCS/linux64";

    # License 授权变量 (指向未来我们要放的 .dat 文件)
    LM_LICENSE_FILE = "${sclHome}/admin/license/Synopsys.dat";
    SNPSLMD_LICENSE_FILE = "27000@localhost";

    # 架构欺骗 (2024版可选，留着防身)
    VCS_ARCH_OVERRIDE = "linux64";
  };

  # ==========================================
  # 🌟 将二进制路径注入系统 PATH
  # ==========================================
  # 这样进入 FHS 环境后，系统能直接找到 vcs、verdi、lmgrd 命令
  home.sessionPath = [
    "${vcsHome}/bin"
    "${verdiHome}/bin"
    "${sclHome}/linux64/bin"
  ];
}

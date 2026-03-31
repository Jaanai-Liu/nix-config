{
  config,
  lib,
  pkgs,
  ...
}:

let
  synopsysHome = "/opt/synopsys";

  vcsHome = "${synopsysHome}/vcs/V-2023.12-SP2";
  verdiHome = "${synopsysHome}/verdi/V-2023.12-SP2";
  sclHome = "${synopsysHome}/scl/2023.09";
in
{
  # ==========================================
  # 🌟 Synopsys 2023 核心环境变量
  # ==========================================
  home.sessionVariables = {
    XILINX_STATIC_HOME = "/opt/Xilinx";
    VC_STATIC_HOME = synopsysHome;

    VCS_HOME = vcsHome;
    VERDI_HOME = verdiHome;
    SCL_HOME = sclHome;

    LD_LIBRARY_PATH = "${verdiHome}/share/PLI/VCS/linux64";

    LM_LICENSE_FILE = "27000@localhost";
    SNPSLMD_LICENSE_FILE = "27000@localhost";

    VERDI_LICENSE_FEATURE = "Verdi";

    VCS_ARCH_OVERRIDE = "linux";
  };

  # ==========================================
  # 🌟 将二进制路径注入系统 PATH
  # ==========================================
  home.sessionPath = [
    "${vcsHome}/bin"
    "${verdiHome}/bin"
    "${sclHome}/linux64/bin"
  ];
}

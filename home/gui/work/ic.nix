{ pkgs, ... }:

let
  # 🎯 核心路径：提取公共变量，告别重复敲代码！
  targetFlake = "github:Jaanai-Liu/xilinx-nix?dir=templates/xilinx";

  # 定义你的 EDA 软件大本营
  synopsysHome = "/opt/synopsys";

  # 定义具体软件的版本路径（以后升级只改这里！）
  vcsHome = "${synopsysHome}/vcs/O-2018.09-SP2";
  vcsMxHome = "${synopsysHome}/vcs-mx/O-2018.09-SP2";
  verdiHome = "${synopsysHome}/verdi_O-2018.09-SP2";
  sclHome = "${synopsysHome}/scl/2018.06";
in
{
  # ==========================================
  # 🌟 1. 全局环境变量 (完美替代原脚本的 export)
  # ==========================================
  home.sessionVariables = {
    XILINX_STATIC_HOME = "/opt/Xilinx";
    VC_STATIC_HOME = synopsysHome;

    # 核心组件库定位
    VCS_HOME = vcsHome;
    VCS_MX_HOME = vcsMxHome;
    VERDI_HOME = verdiHome;
    DVE_HOME = vcsHome;
    SCL_HOME = sclHome;

    # 系统架构欺骗 (极其关键，很多老软件靠这个识别 Linux)
    VCS_ARCH_OVERRIDE = "linux";

    # PLI 动态库路径 (为了 Verdi 能够顺利抓取 VCS 的波形)
    LD_LIBRARY_PATH = "${verdiHome}/share/PLI/VCS/LINUX64";

    # License 双保险配置
    LM_LICENSE_FILE = "27000@localhost";
    SNPSLMD_LICENSE_FILE = "27000@localhost";
  };

  # ==========================================
  # 🌟 2. 全局 PATH 注入 (完美替代原脚本的 alias 和 PATH)
  # ==========================================
  # Nix 会自动把这些目录塞进系统的 PATH 里，你直接敲 vcs、verdi、dve 就能秒开！
  home.sessionPath = [
    "${vcsHome}/bin"
    "${vcsHome}/gui/dve/bin"
    "${verdiHome}/bin"
    "${sclHome}/linux64/bin"
  ];

  # ==========================================
  # 🌟 3. 你的工作站快捷启动命令
  # ==========================================
  home.packages = with pkgs; [

    # 一键进入带彩色欢迎界面、包含所有工具的终极 Shell
    (writeShellScriptBin "ic-shell" ''
      echo "🚀 正在开启 IC 联合开发工作站..."
      exec nix develop "${targetFlake}" --impure -c "$SHELL"
    '')

    # 纯粹的 VCS FHS 环境 (不附带额外项目脚本，仅挂载环境)
    (writeShellScriptBin "ic-env-vcs" ''
      exec nix run "${targetFlake}#vcs-fhs-env" --impure -- "$@"
    '')

    # 纯粹的 Vivado FHS 环境
    (writeShellScriptBin "ic-env-vivado" ''
      exec nix run "${targetFlake}#xilinx-fhs-env" --impure -- "$@"
    '')

    # 收集源码并自动生成 filelist.f
    (writeShellScriptBin "ic-rtl-build" ''
      echo "🛠️ 正在收集 RTL 源码并生成 filelist..."
      exec nix build "${targetFlake}#demo.rtl" --impure
    '')

    # 使用 VCS 运行基础仿真 (无波形)
    (writeShellScriptBin "ic-rtl-vcs" ''
      exec nix run "${targetFlake}#demo.vcs" --impure -- "$@"
    '')

    # 使用 VCS 运行仿真，并强制输出 FSDB 波形文件
    (writeShellScriptBin "ic-rtl-vcs-wave" ''
      echo "🌊 正在运行带波形的 VCS 仿真..."
      exec nix run "${targetFlake}#demo.vcs-trace" --impure -- +dump-start=0 +dump-end=10000 +wave-path=trace "$@"
    '')

    # 使用 Verilator 运行开源仿真
    (writeShellScriptBin "ic-rtl-verilator" ''
      exec nix run "${targetFlake}#demo.verilated" --impure -- "$@"
    '')

    # 一键呼出 Verdi 并自动加载波形
    (writeShellScriptBin "ic-rtl-verdi" ''
      echo "👁️ 正在启动 Verdi 查阅波形..."
      exec nix run "${targetFlake}#demo.verdi" --impure -- "$@"
    '')

    # 一键编译 Xilinx 仿真库供 VCS 使用
    (writeShellScriptBin "ic-xilinx-simlib" ''
      echo "📚 正在为 VCS 编译 Vivado 仿真底层库..."
      exec nix run "${targetFlake}#xilinx-simlib" --impure -- "$@"
    '')

    # Xilinx + VCS 联合仿真自动化流水线
    (writeShellScriptBin "ic-xilinx-sim" ''
      echo "⚙️ 正在执行 Xilinx + VCS 联合仿真自动化流水线..."
      exec nix run "${targetFlake}#demo.vivado-sim-run" --impure -- "$@"
    '')

    # 查阅联合仿真产生的波形
    (writeShellScriptBin "ic-xilinx-wave" ''
      echo "👁️ 正在查阅联合仿真波形..."
      exec nix run "${targetFlake}#demo.vivado-view-waves" --impure -- "$@"
    '')

    # 清理编译垃圾
    (writeShellScriptBin "ic-clean" ''
      echo "🧹 正在清理工程中间件和临时文件..."
      exec nix run "${targetFlake}#clean" --impure
    '')

    # 格式化代码
    (writeShellScriptBin "ic-fmt" ''
      echo "✨ 正在格式化代码..."
      exec nix fmt "${targetFlake}"
    '')

  ];
}

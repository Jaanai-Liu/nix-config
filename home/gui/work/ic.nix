{ pkgs, myvars, ... }:
let
  # 🎯 核心路径：指向你本地拷贝过来的那个作者配置的文件夹
  # 【注意】请确认这个路径是你存放 xilinx 文件夹的真实绝对路径！
  # targetFlake = "path:/home/zheng/nix-config/xilinx";
  targetFlake = "github:Jaanai-Liu/xilinx-nix?dir=templates/xilinx";
in
{
  home.sessionVariables = {
    XILINX_STATIC_HOME = "/opt/Xilinx";
    VC_STATIC_HOME = "/opt/synopsys";
    LM_LICENSE_FILE = "27000@localhost";
  };

  home.packages = with pkgs; [

    # ==========================================
    # 🌟 1. 核心交互环境 (进入隔离结界)
    # ==========================================

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

    # ==========================================
    # 🌟 2. 基础 RTL 仿真流 (纯 RTL，无 Xilinx IP)
    # ==========================================

    # 收集源码并自动生成 filelist.f (每次修改代码增加文件后运行)
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

    # 使用 Verilator 运行开源仿真 (如果你想用免费工具测一下)
    (writeShellScriptBin "ic-rtl-verilator" ''
      exec nix run "${targetFlake}#demo.verilated" --impure -- "$@"
    '')

    # 一键呼出 Verdi 并自动加载刚才生成的波形和设计库
    (writeShellScriptBin "ic-rtl-verdi" ''
      echo "👁️ 正在启动 Verdi 查阅波形..."
      exec nix run "${targetFlake}#demo.verdi" --impure -- "$@"
    '')

    # ==========================================
    # 🌟 3. 联合仿真自动化流水线 (包含 Xilinx IP)
    # ==========================================

    # 一键编译 Xilinx 仿真库供 VCS 使用 (只需运行一次，耗时较长)
    (writeShellScriptBin "ic-xilinx-simlib" ''
      echo "📚 正在为 VCS 编译 Vivado 仿真底层库..."
      exec nix run "${targetFlake}#xilinx-simlib" --impure -- "$@"
    '')

    # 自动化流水线：Vivado 生成 IP -> 自动改路径 -> VCS 编译与仿真
    (writeShellScriptBin "ic-xilinx-sim" ''
      echo "⚙️ 正在执行 Xilinx + VCS 联合仿真自动化流水线..."
      exec nix run "${targetFlake}#demo.vivado-sim-run" --impure -- "$@"
    '')

    # 自动搜寻联合仿真产生的 .fsdb 波形并启动 Verdi
    (writeShellScriptBin "ic-xilinx-wave" ''
      echo "👁️ 正在查阅联合仿真波形..."
      exec nix run "${targetFlake}#demo.vivado-view-waves" --impure -- "$@"
    '')

    # ==========================================
    # 🌟 4. 辅助工程管理工具
    # ==========================================

    # 清理编译产生的垃圾文件 (调用 git clean)
    (writeShellScriptBin "ic-clean" ''
      echo "🧹 正在清理工程中间件和临时文件..."
      exec nix run "${targetFlake}#clean" --impure
    '')

    # 格式化代码 (支持 Nix 和 Verilog)
    (writeShellScriptBin "ic-fmt" ''
      echo "✨ 正在格式化代码..."
      exec nix fmt "${targetFlake}"
    '')

  ];
}

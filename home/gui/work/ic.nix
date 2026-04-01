{
  config,
  pkgs,
  lib,
  myvars,
  osConfig,
  ...
}:

let
  isSynopsysEnabled = osConfig.modules.synopsys.enable;

  # targetFlake = "github:Jaanai-Liu/xilinx-nix?dir=templates/xilinx";
  targetFlake = "/home/${myvars.username}/xilinx-nix?dir=templates/xilinx";
in
{
  # config = lib.mkIf cfg.enaddble {
  config = lib.mkIf isSynopsysEnabled {

    # ==========================================
    # 🌟 IC 工作站快捷启动指令集
    # ==========================================
    home.packages = with pkgs; [

      # ----------------------------------------
      # 🔴 核心环境进入指令 (不执行具体任务，仅进入环境)
      # ----------------------------------------

      # 一键进入带彩色欢迎界面、包含所有工具的终极 Shell
      (writeShellScriptBin "ic-shell" ''
        echo "🚀 正在开启 IC 联合开发工作站..."
        exec nix develop "${targetFlake}" --impure -c "$SHELL"
      '')

      # 纯粹的 VCS FHS 环境 (打补丁、手动调试专用)
      (writeShellScriptBin "ic-env-vcs" ''
        exec nix run "${targetFlake}#vcs-fhs-env" --impure -- "$@"
      '')

      # 纯粹的 Vivado FHS 环境
      (writeShellScriptBin "ic-env-vivado" ''
        exec nix run "${targetFlake}#xilinx-fhs-env" --impure -- "$@"
      '')

      # ----------------------------------------
      # 🔵 编译与仿真自动化流水线
      # ----------------------------------------

      # 收集源码并自动生成 filelist.f
      (writeShellScriptBin "ic-rtl-build" ''
        echo "🛠️ 正在收集 RTL 源码并生成 filelist..."
        exec nix build "${targetFlake}#demo.rtl" --impure
      '')

      # 使用 VCS 运行基础仿真 (无波形)
      (writeShellScriptBin "ic-rtl-vcs" ''
        exec nix run "${targetFlake}#demo.vcs" --impure -- "$@"
      '')

      # 使用 VCS-MX 运行混合仿真 (2024版已集成进主程序)
      (writeShellScriptBin "ic-rtl-vcsmx" ''
        echo "🛠️ 正在使用 VCS 混合模式运行仿真..."
        # 假设你在 targetFlake 里有对应的 vcs-fhs-env
        exec nix run "${targetFlake}#vcs-fhs-env" --impure -- vcs -full64 -sverilog "$@"
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

      # ----------------------------------------
      # 🟢 Xilinx 联合仿真指令
      # ----------------------------------------

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

      # ----------------------------------------
      # 🟡 工程维护指令
      # ----------------------------------------

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
  };
}

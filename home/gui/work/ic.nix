{
  config,
  pkgs,
  inputs,
  ...
}:
{
  home.sessionVariables = {
    XILINX_STATIC_HOME = "/opt/Xilinx";
    VC_STATIC_HOME = "/opt/synopsys";
  };

  home.packages = [
    (pkgs.writeShellScriptBin "ic-vcs" ''
      echo "🚀 正在开启 VCS 仿真隔离结界..."
      # 这里直接调用你仓库里导出的 vcs-fhs-env 包
      exec ${inputs.xilinx-nix.packages.${pkgs.system}.vcs-fhs-env}/bin/vcs-install-env "$@"
    '')

    (pkgs.writeShellScriptBin "ic-xilinx" ''
      echo "🚀 正在开启 Xilinx 开发隔离结界..."
      # 直接调用仓库导出的 xilinx-fhs-env 包
      # 注意：假设你的 xilinx_fhs_install.nix 里定义的 name 是 xilinx-install-env
      exec ${inputs.xilinx-nix.packages.${pkgs.system}.xilinx-fhs-env}/bin/xilinx-install-env "$@"
    '')

    (pkgs.writeShellScriptBin "ic-init" ''
      echo "📦 正在当前目录初始化 FPGA/IC 工程模板..."
      nix flake init -t github:Jaanai-Liu/xilinx-nix#xilinx
      echo "✅ 初始化完成！"
    '')
  ];
}

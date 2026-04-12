# 为了不使用默认的 rime-data，改用我自定义的小鹤音形数据与雾凇拼音数据，这里需要 override
# 参考 https://github.com/NixOS/nixpkgs/blob/e4246ae1e7f78b7087dce9c9da10d28d3725025f/pkgs/tools/inputmethods/fcitx5/fcitx5-rime.nix
{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      # 1. 雾凇拼音：动态打包
      # Fcitx5-Rime 要求词库必须在 share/rime-data 目录下，我们用脚本自动构建这个结构
      rime-data-ice = ./rime-data-ice;
      # rime-data-ice = super.runCommandLocal "rime-data-ice" { } ''
      #   mkdir -p $out/share/rime-data
      #   cp -r ${./rime-ice}/* $out/share/rime-data/
      # '';

      # 2. 小鹤音形
      # 小鹤音形配置，配置来自 flypy.com 官方网盘的鼠须管配置压缩包「小鹤音形“鼠须管”for macOS.zip」
      # 仅修改了 default.yaml 文件，将其中的半角括号改为了直角括号「 与 」。
      rime-data = ./rime-data-flypy;

      # 3. 全局覆盖 fcitx5-rime，将小鹤和雾凇同时塞进 rimeDataPkgs！
      fcitx5-rime = prev.fcitx5-rime.override {
        rimeDataPkgs = [
          ./rime-data-flypy
          ./rime-data-ice
          # self.rime-data-ice
        ];
      };

      # used by macOS Squirrel
      flypy-squirrel = ./rime-data-flypy;
    })
  ];
}

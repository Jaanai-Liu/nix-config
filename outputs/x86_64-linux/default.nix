# outputs/x86_64-linux/default.nix
# args: {
#   "lz-pc" = import ./lz-pc.nix args;
#   "lz-laptop" = import ./lz-laptop.nix args;
#   "lz-vps" = import ./lz-vps.nix args;
# }
{
  lib,
  inputs,
  ...
}@args:
let
  inherit (inputs) haumea;

  # 🌟 第一步：利用 haumea 自动加载 ./hosts 目录下的所有内容
  # 它会递归扫描该目录，把每个 .nix 文件加载为一个属性
  data = haumea.lib.load {
    src = ./hosts;
    inputs = args; # 将 inputs, lib 等参数透传给子模块
  };

  # 🌟 第二步：提取所有机器的数据
  # data 目前是一个类似 { "lz-pc" = {...}; "lz-vps" = {...}; } 的集合
  # 我们用 attrValues 把它们转成一个列表 [{...}, {...}]
  dataWithoutPaths = builtins.attrValues data;

  # 🌟 第三步：定义最终输出
  outputs = {
    # 自动合并所有主机的 nixosConfigurations
    nixosConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.nixosConfigurations or { }) dataWithoutPaths
    );

    # 自动合并所有主机的 colmena 配置（用于远程自动部署）
    colmena = lib.attrsets.mergeAttrsList (map (it: it.colmena or { }) dataWithoutPaths);

    # 如果以后有 colmena 相关的元数据，也在这里合并
    colmenaMeta = {
      nodeNixpkgs = lib.attrsets.mergeAttrsList (
        map (it: it.colmenaMeta.nodeNixpkgs or { }) dataWithoutPaths
      );
      nodeSpecialArgs = lib.attrsets.mergeAttrsList (
        map (it: it.colmenaMeta.nodeSpecialArgs or { }) dataWithoutPaths
      );
    };
  };
in
outputs // { inherit data; }

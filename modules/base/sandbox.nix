{ config, pkgs, ... }:
{
  # 允许 Nix 构建时访问外部网络（VCS License 检查必备）
  nix.settings.sandbox = "relaxed";
}

{ pkgs, ... }:
{
    home.packages = with pkgs; [
        wl-clipboard # 底层工具
        cliphist     # 历史管理
    ];
}
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    qq
    wechat-uos
    feishu
    telegram-desktop
    discord
  ];
}

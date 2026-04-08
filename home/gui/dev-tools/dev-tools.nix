{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # vscode
    antigravity
    android-studio
    android-tools
  ];
}

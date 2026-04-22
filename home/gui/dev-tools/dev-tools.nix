{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # vscode
    # antigravity
    claude-code
    android-studio
    android-tools
  ];
}

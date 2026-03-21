{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # vscode
    # micromamba
    antigravity
    android-studio
  ];
}

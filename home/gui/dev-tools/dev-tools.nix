{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # vscode
    # antigravity
    claude-code
    litellm

    android-studio
    android-tools
  ];
}

{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # vscode
    micromamba
  ];
}

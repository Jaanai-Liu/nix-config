{ pkgs, ... }:

{
  home.packages = [ pkgs.devenv ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableZshIntegration = true;
    enableBashIntegration = true;

    config = {
      global = {
        # 当进入目录时，不显示那一长串环境变量的变化（只保留加载提示）
        hide_env_diff = true;
      };
    };
  };
  programs.zsh.shellAliases = {
    dev-start = "devenv init && echo 'use devenv' > .envrc && direnv allow";
  };
}

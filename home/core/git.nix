# modules/git.nix
{ config, pkgs, ... }:
{
  # === Git 配置 ===
  programs.git = {
    enable = true;

    settings = {
      # 用户信息
      user = {
        name = "Jaanai-Liu";
        email = "liujaanai@gmail.com";
      };

      # 初始化设置
      init = {
        defaultBranch = "main";
      };

      # 核心设置
      core = {
        fileMode = false;
        # editor = "vim";  # 默认编辑器
      };

      alias = {
        ci = "commit";
        co = "checkout";
        st = "status";
      };

      # 代理设置 (如果有)
      # http = { proxy = "http://127.0.0.1:7897"; };
      # https = { proxy = "http://127.0.0.1:7897"; };
    };
  };
}

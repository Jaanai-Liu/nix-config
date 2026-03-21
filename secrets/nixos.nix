{
  lib,
  config,
  pkgs,
  agenix,
  mysecrets,
  myvars,
  ...
}:
with lib;
let
  cfg = config.modules.secrets;

  enabledServerSecrets =
    cfg.server.application.enable
    || cfg.server.network.enable
    || cfg.server.operation.enable
    || cfg.server.kubernetes.enable
    || cfg.server.webserver.enable
    || cfg.server.storage.enable;

  noaccess = {
    mode = "0000";
    owner = "root";
  };
  high_security = {
    mode = "0500";
    owner = "root";
  };
  user_readable = {
    mode = "0500";
    owner = myvars.username;
  };
in
{
  imports = [
    agenix.nixosModules.default
  ];

  options.modules.secrets = {
    desktop.enable = mkEnableOption "NixOS Secrets for Desktops";
  };

  config = mkIf cfg.desktop.enable {
    # 安装 agenix 命令行工具，方便你在终端编辑加密文件
    environment.systemPackages = [
      agenix.packages."${pkgs.stdenv.hostPlatform.system}".default
    ];

    # 指定解密用的“钥匙”路径。对于普通系统，使用机器自身的 SSH 主机密钥
    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
    ];

    age.secrets = {
      # 定义你的私钥。file 路径指向你从 GitHub 下载的仓库
      "ssh-key.age" = {
        file = "${mysecrets}/secrets/ssh-key.age"; # 假设你存放在这个位置
      }
      // user_readable;
      "github-token" = {
        file = "${mysecrets}/secrets/github-token.age";
      }
      // high_security;
    };

    # ==========================================
    # 🌟 2. 将解密后的 Token 注入 Nix 系统配置
    # ==========================================
    # 我们使用 !include 语法，这样 Token 内容永远不会进入 /nix/store
    nix.extraOptions = ''
      !include ${config.age.secrets."github-token".path}
    '';

    # 将解密后的私钥软链接到 /etc/ssh 或其它你想要的地方（可选）
    # 通常 SSH 会自动寻找 ~/.ssh/，你也可以在 home-manager 里处理软链接
    environment.etc = {
      "agenix/id_ed25519" = {
        source = config.age.secrets."ssh-key.age".path;
        mode = "0500";
        user = myvars.username;
      };
    };

    age.secrets."rclone-alist" = {
      file = "${mysecrets}/secrets/rclone-alist.age";
      path = "/home/${myvars.username}/.config/rclone/rclone.conf";
      owner = myvars.username;
      group = "users";
      mode = "0500";
    };
  };
}


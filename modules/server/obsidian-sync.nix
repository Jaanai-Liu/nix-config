# modules/server/obsidian-sync/obsidian-sync.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.services.obsidian-sync;
in
{
  options.modules.services.obsidian-sync = {
    enable = lib.mkEnableOption "Obsidian LiveSync Server (CouchDB)";

    # 后续可通过 agenix 注入，目前先写明文测试
    domain = lib.mkOption {
      type = lib.types.str;
      default = "sync.yourdomain.com";
      description = "同步服务器公网域名";
    };

    adminUser = lib.mkOption {
      type = lib.types.str;
      default = "zheng";
      description = "CouchDB 管理员用户名";
    };

    adminPass = lib.mkOption {
      type = lib.types.str;
      default = "your_password_here";
      description = "CouchDB 管理员密码";
    };
  };

  config = lib.mkIf cfg.enable {

    # 核心数据库服务
    services.couchdb = {
      enable = true;
      bindAddress = "127.0.0.1";
      port = 5984;

      adminUser = cfg.adminUser;
      adminPass = cfg.adminPass;

      # 跨域及附件大小配置，LiveSync 插件必须项
      extraConfig = {
        httpd = {
          enable_cors = "true";
        };
        cors = {
          origins = "app://obsidian.md,capacitor://localhost,http://localhost";
          credentials = "true";
          headers = "accept, authorization, content-type, origin, referer";
          methods = "GET, PUT, POST, HEAD, DELETE";
          max_age = "3600";
        };
        couchdb = {
          max_document_size = "50000000"; # 50MB
        };
      };
    };

    # Nginx 反向代理与 HTTPS
    services.nginx = {
      enable = true;
      virtualHosts."${cfg.domain}" = {
        enableACME = true;
        forceSSL = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:5984";
          proxyWebsockets = true;
          extraConfig = ''
            client_max_body_size 50M;
          '';
        };
      };
    };

    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}

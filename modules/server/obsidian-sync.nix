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

    domain = lib.mkOption {
      type = lib.types.str;
      default = "sync.114132.xyz";
      description = "Public domain name for the sync server";
    };

    adminUser = lib.mkOption {
      type = lib.types.str;
      default = "obsidian_admin";
      description = "CouchDB administrator username";
    };

    adminPass = lib.mkOption {
      type = lib.types.str;
      default = "ObsidianLiveSync#2026@Secure!";
      description = "CouchDB administrator password";
    };
  };

  config = lib.mkIf cfg.enable {

    # 1. Core Database Service: CouchDB
    services.couchdb = {
      enable = true;
      # Bind to localhost only for security. Nginx will handle external access.
      bindAddress = "127.0.0.1";
      port = 5984;

      adminUser = cfg.adminUser;
      adminPass = cfg.adminPass;

      # CORS and attachment size limits required by the Obsidian LiveSync plugin
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
          # Allow attachments up to 50MB (e.g., images, PDFs in notes)
          max_document_size = "50000000";
        };
      };
    };

    # 2. Reverse Proxy and HTTPS: Nginx
    services.nginx = {
      enable = true;
      virtualHosts."${cfg.domain}" = {
        # Automatically request and renew Let's Encrypt SSL certificates
        enableACME = true;
        # Force all HTTP traffic to HTTPS for secure syncing
        forceSSL = true;

        locations."/" = {
          proxyPass = "http://127.0.0.1:5984";
          proxyWebsockets = true;
          extraConfig = ''
            # Must match or exceed the CouchDB max_document_size
            client_max_body_size 50M;
          '';
        };
      };
    };

    # 3. Open standard web ports in the firewall
    networking.firewall.allowedTCPPorts = [
      80
      443
    ];
  };
}

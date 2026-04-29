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

    # Since you are using Cloudflare Tunnel, we only need to configure CouchDB
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
      # Bind to localhost because Cloudflare Tunnel accesses it locally
      bindAddress = "127.0.0.1";
      port = 5984;

      adminUser = cfg.adminUser;
      adminPass = cfg.adminPass;

      # CRITICAL: CORS and attachment size limits required by Obsidian LiveSync plugin
      extraConfig = {
        httpd = {
          enable_cors = "true";
        };
        cors = {
          # These origins allow the Obsidian desktop and mobile apps to connect
          origins = "app://obsidian.md,capacitor://localhost,http://localhost";
          credentials = "true";
          headers = "accept, authorization, content-type, origin, referer";
          methods = "GET, PUT, POST, HEAD, DELETE";
          max_age = "3600";
        };
        couchdb = {
          # Allow sync of larger attachments (images, PDFs) up to 50MB
          max_document_size = "50000000";
        };
      };
    };

    # Note: No Nginx or Firewall ports 80/443 needed here
    # because Cloudflare Tunnel (lz-ali-tunnel) handles the traffic.
  };
}

# modules/server/obsidian-sync/obsidian-sync.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.services.obsidian-sync;
  name = "obsidian-sync";
in
{
  options.modules.services.obsidian-sync = {
    enable = lib.mkEnableOption "Obsidian LiveSync Server (CouchDB via Docker)";
  };

  config = lib.mkIf cfg.enable {

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    systemd.tmpfiles.rules = [
      # "d /var/lib/${name} 0755 1000 1000 -"
      "d /var/lib/${name} 0755 5984 5984 -"
    ];

    virtualisation.oci-containers.containers.${name} = {
      image = "couchdb:3.3.3";
      # image = "m.daocloud.io/docker.io/library/couchdb:3.3.3";

      environmentFiles = [
        config.age.secrets."obsidian-sync-env".path
      ];

      volumes = [
        "/var/lib/${name}:/opt/couchdb/data"
        "${
          pkgs.writeText "cors.ini" (
            lib.generators.toINI { } {
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
                max_document_size = "50000000";
              };
            }
          )
        }:/opt/couchdb/etc/local.d/99-cors.ini:ro"
      ];

      ports = [ "127.0.0.1:5984:5984" ];

      log-driver = "journald";
    };
  };
}

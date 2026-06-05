# modules/server/rustdesk-api.nix
{
  config,
  lib,
  ...
}:

let
  cfg = config.modules.services.rustdesk-api;
  name = "rustdesk-api";
in
{
  options.modules.services.rustdesk-api = {
    enable = lib.mkEnableOption "RustDesk Web API Server (Docker container, lejianwen version)";
  };

  config = lib.mkIf cfg.enable {

    virtualisation.docker.enable = true;
    virtualisation.oci-containers.backend = "docker";

    networking.firewall.allowedTCPPorts = [ 21114 ];

    virtualisation.oci-containers.containers.${name} = {
      image = "docker.linkos.org/lejianwen/rustdesk-api@sha256:ed35016339d3bcadf15c7bb3ae8490af1e3950c33f58fd2261ae009b94f5de45";
      environmentFiles = [
        config.age.secrets."rustdesk-api-env".path
      ];
      volumes = [
        "/var/lib/${name}/api:/app/data:rw"
      ];
      log-driver = "journald";
      extraOptions = [
        "--network=host"
      ];
    };

    systemd.services."docker-${name}" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
      };
    };

    systemd.tmpfiles.rules = [
      "d /var/lib/${name}/api 0755 1000 1000 -"
    ];
  };
}

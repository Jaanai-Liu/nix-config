# modules/server/siyuan-server/siyuan-server.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.services.siyuan-server;
  name = "siyuan-server";
in
{
  options.modules.services.siyuan-server = {
    enable = lib.mkEnableOption "SiYuan Note Server";

    workspaceDir = lib.mkOption {
      type = lib.types.str;
      default = "/siyuan_data";
    };
  };

  config = lib.mkIf cfg.enable {

    systemd.tmpfiles.rules = [
      "d ${cfg.workspaceDir} 0755 1000 1000 -"
    ];

    virtualisation.oci-containers.containers.${name} = {
      image = "b3log/siyuan:v3.1.0";

      environment = {
        TZ = "Asia/Shanghai";
        PUID = "1000";
        PGID = "1000";
      };

      environmentFiles = [
        config.age.secrets."siyuan-server-env".path
      ];

      volumes = [
        "${cfg.workspaceDir}:/siyuan/workspace:rw"
        "${./siyuan-server-entry.sh}:/siyuan/entrypoint.sh:ro"
      ];

      ports = [ "6806:6806" ];

      entrypoint = "/siyuan/entrypoint.sh";

      cmd = [
        "--workspace=/siyuan/workspace/"
      ];

      log-driver = "journald";
    };

    systemd.services."docker-${name}" = {
      serviceConfig = {
        Restart = lib.mkOverride 90 "always";
        RestartMaxDelaySec = lib.mkOverride 90 "1m";
        RestartSec = lib.mkOverride 90 "100ms";
        RestartSteps = lib.mkOverride 90 9;
      };
    };

    # 4. Tailscale 防火墙隔离
    networking.firewall.interfaces."tailscale0".allowedTCPPorts = [ 6806 ];
  };
}

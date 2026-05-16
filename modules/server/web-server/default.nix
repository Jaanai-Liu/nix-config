{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.modules.services.web-server;
in
{
  options.modules.services.web-server = {
    enable = mkEnableOption "114132.xyz Web Server (via CF Tunnel)";
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts."114132.xyz" = {
        listen = [
          {
            addr = "127.0.0.1";
            port = 80;
          }
        ];
        extraConfig = "ssi on;";
        locations."/" = {
          root = "${./blog/dist}";
          index = "index.html";
        };
      };
    };

    systemd.services.cloudflare-tunnel = {
      description = "Cloudflare Tunnel for 114132.xyz";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];
      serviceConfig = {
        EnvironmentFile = config.age.secrets."cf-tunnel-env".path;
        ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run";
        Restart = "always";
        RestartSec = "5s";
        DynamicUser = true;
      };
    };
  };
}

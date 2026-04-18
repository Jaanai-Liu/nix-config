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
        locations."/" = {
          root = "${./homepage}";
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
        # ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token YOUR_TOKEN";
        ExecStart = "${pkgs.cloudflared}/bin/cloudflared tunnel --no-autoupdate run --token eyJhIjoiYjA2YzE5MWIzMjA0OTRhMzQ3OTdlYTQ3MWIzYzYzYmEiLCJ0IjoiNDhiNDk0MzEtMTk0OC00NzdmLTgwYzYtYzUxNGIyMDkxYWVjIiwicyI6Ik5XSmlOMlJsTXpRdE1qQXhZaTAwTm1GaUxUbGlZbVl0TkRjd01EUmhOVE5rWldReiJ9";
        Restart = "always";
        RestartSec = "5s";
        DynamicUser = true;
      };
    };

    # networking.firewall.allowedTCPPorts = [ 80 443 ]; # 删掉或注释掉这行
  };
}

# modules/server/rustdesk-server.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.services.rustdesk-server;
in
{
  options.modules.services.rustdesk-server = {
    enable = lib.mkEnableOption "RustDesk Server (hbbs + hbbr, lejianwen Pro version)";
  };

  config = lib.mkIf cfg.enable {
    services.rustdesk-server = {
      enable = true;
      package = pkgs.rustdesk-server-pro;
      signal = {
        enable = true;
        extraArgs = [
          "-c"
          "${config.age.secrets."hbbs-conf".path}"
        ];
      };
      relay.enable = true;
      openFirewall = true;
    };

    # Use config file for hbbs (override default ExecStart)
    systemd.services.rustdesk-signal = {
      serviceConfig.ExecStart = lib.mkForce "${pkgs.rustdesk-server-pro}/bin/hbbs -c ${config.age.secrets."hbbs-conf".path}";
    };

    # Allow port 21114 (API server — separate Docker container)
    networking.firewall.allowedTCPPorts = [ 21114 ];
  };
}

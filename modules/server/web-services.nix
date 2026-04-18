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
    enable = mkEnableOption "114132.xyz Web服务";
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      virtualHosts."114132.xyz" = {
        locations."/" = {
          extraConfig = ''
            default_type text/plain;
            return 200 "Hello, this is lz-ali server running NixOS!\nDomain: 114132.xyz";
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

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
    enable = mkEnableOption "114132.xyz Web Server";
  };

  config = mkIf cfg.enable {
    systemd.tmpfiles.rules = [
      "d /var/www/114132_files 0755 nginx nginx - -"
    ];

    services.nginx = {
      enable = true;
      virtualHosts."114132.xyz" = {
        locations."/" = {
          root = "${./homepage}";
          index = "index.html";
        };

        locations."/files/" = {
          alias = "/var/www/114132_files/";
          extraConfig = ''
            autoindex on;
            autoindex_exact_size off;
            autoindex_localtime on;   
            charset utf-8;        
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

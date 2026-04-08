{
  lib,
  config,
  pkgs,
  mysercts,
  ...
}:
with lib;
let
  cfg = config.modules.services.sing-box;
in
{
  options.modules.services.sing-box = {
    enable = mkEnableOption "Sing-box server service";
  };
  config = mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 443 ];
    networking.firewall.allowedUDPPorts = [
      443
      8443
    ];

    services.sing-box = {
      enable = true;
      settings = {
        inbounds = [
          {
            type = "vless";
            tag = "vless-in";
            listen = "::";
            listen_port = 443;
            users = [
              {
                uuid._secret = config.age.secrets."sing-box-uuid".path;
                flow = "xtls-rprx-vision";
              }
            ];
            tls = {
              enabled = true;
              server_name = "www.microsoft.com";
              reality = {
                enabled = true;
                handshake = {
                  server = "www.microsoft.com";
                  server_port = 443;
                };
                private_key._secret = config.age.secrets."sing-box-private-key".path;
                short_id = [
                  { _secret = config.age.secrets."sing-box-short-id".path; }
                ];
              };
            };
          }
          {
            type = "shadowsocks";
            tag = "ss-udp-in";
            listen = "::";
            listen_port = 8443;
            method = "2022-blake3-aes-128-gcm";
            password._secret = config.age.secrets."sing-box-hy2-pass".path;
          }
        ];
        outbounds = [
          {
            type = "direct";
            tag = "direct";
          }
        ];
      };
    };

    systemd.services.sing-box.preStart = ''
      if [ ! -f /var/lib/sing-box/cert.pem ]; then
        ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:2048 -keyout /var/lib/sing-box/key.pem -out /var/lib/sing-box/cert.pem -sha256 -days 3650 -nodes -subj "/CN=www.microsoft.com"
        chown sing-box:sing-box /var/lib/sing-box/*.pem
      fi
    '';
  };
}

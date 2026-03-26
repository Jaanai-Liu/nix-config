{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ v2rayn ];

  security.wrappers.xray = {
    owner = "root";
    group = "root";
    capabilities = "cap_net_admin,cap_net_bind_service+ep";
    source = "${pkgs.xray}/bin/xray";
  };

  systemd.tmpfiles.rules = [
    "d /home/zheng/.local/share/v2rayN/bin 0755 zheng users -"
    "d /home/zheng/.local/share/v2rayN/bin/xray 0755 zheng users -"

    "L+ /home/zheng/.local/share/v2rayN/bin/xray/xray - - - - /run/wrappers/bin/xray"

    "L+ /home/zheng/.local/share/v2rayN/bin/geoip.dat - - - - ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat"
    "L+ /home/zheng/.local/share/v2rayN/bin/geosite.dat - - - - ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat"
  ];
}

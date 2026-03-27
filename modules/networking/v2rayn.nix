{
  config,
  pkgs,
  myvars,
  ...
}:

{
  environment.systemPackages = with pkgs; [
    v2rayn
    xray
    sing-box
  ];

  security.wrappers = {
    xray = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin,cap_net_bind_service+ep";
      source = "${pkgs.xray}/bin/xray";
    };
    sing-box = {
      owner = "root";
      group = "root";
      capabilities = "cap_net_admin,cap_net_bind_service+ep";
      source = "${pkgs.sing-box}/bin/sing-box";
    };
  };

  systemd.tmpfiles.rules = [
    "d /home/${myvars.username}/.local/share/v2rayN/bin 0755 ${myvars.username} users -"
    "d /home/${myvars.username}/.local/share/v2rayN/bin/xray 0755 ${myvars.username} users -"
    "d /home/${myvars.username}/.local/share/v2rayN/bin/sing_box 0755 ${myvars.username} users -"

    # 链接 Xray
    "L+ /home/${myvars.username}/.local/share/v2rayN/bin/xray/xray - - - - /run/wrappers/bin/xray"
    # 链接 Sing-box (注意：目录名是 sing_box，文件名是 sing-box)
    "L+ /home/${myvars.username}/.local/share/v2rayN/bin/sing_box/sing-box - - - - /run/wrappers/bin/sing-box"

    # 地图文件
    "L+ /home/${myvars.username}/.local/share/v2rayN/bin/geoip.dat - - - - ${pkgs.v2ray-geoip}/share/v2ray/geoip.dat"
    "L+ /home/${myvars.username}/.local/share/v2rayN/bin/geosite.dat - - - - ${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat"
  ];
}

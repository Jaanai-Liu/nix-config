# vars/networking.nix
{ lib }:
let
  # 1. 你的设备地址簿
  hostsAddr = {
    lz-pc = {
      ipv4 = "100.81.104.63"; # Tailscale IP
      user = "zheng";
    };
    lz-nb = {
      ipv4 = "100.x.y.z"; # 你的笔记本 IP
      user = "zheng";
    };
    lz-vps = {
      ipv4 = "23.95.28.22"; # 🌟 你的 VPS 公网 IP
      user = "root";
    };
  };
in
{
  inherit hostsAddr;

  sshExtraConfig = lib.attrsets.foldlAttrs (
    acc: host: val:
    acc
    + ''
      Host ${host}
        HostName ${val.ipv4}
        User ${val.user}
        # 如果你以后改了 SSH 端口，可以在这里加 Port 字段
    ''
  ) "" hostsAddr;
}

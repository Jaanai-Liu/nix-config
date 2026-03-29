# vars/networking.nix
{ lib }:
let
  # 1. 你的设备地址簿
  hostsAddr = {
    lz-pc = {
      ipv4 = "100.81.104.63";
      user = "myvars.username";
    };
    lz-nb = {
      ipv4 = "100.x.y.z";
      user = "myvars.username";
    };
    lz-vps = {
      ipv4 = "23.95.28.22";
      user = "root";
    };
    lz-vps-home = {
      ipv4 = "23.95.28.22";
      user = "myvars.username";
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
        # 如果以后改了 SSH 端口，可以在这里加 Port 字段
    ''
  ) "" hostsAddr;
}

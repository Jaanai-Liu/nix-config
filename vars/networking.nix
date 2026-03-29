# vars/networking.nix
{ lib }:
let
  sshDefault = {
    port = 22;
    user = "zheng";
  };
in
rec {
  hostsAddr = {
    lz-pc.ipv4 = "100.81.104.63";
    lz-nb.ipv4 = "100.x.y.z";
    lz-vps = {
      ipv4 = "23.95.28.22";
      ssh.user = "root";
    };
    lz-vps-home.ipv4 = "23.95.28.22";
  };

  sshExtraConfig = lib.attrsets.foldlAttrs (
    acc: host: val:
    let
      ssh = sshDefault // (if val ? ssh then val.ssh else { });
    in
    acc
    + ''
      Host ${host}
        HostName ${val.ipv4}
        Port ${toString (ssh.port or 22)}
        User ${ssh.user}
    ''
  ) "" hostsAddr;
}

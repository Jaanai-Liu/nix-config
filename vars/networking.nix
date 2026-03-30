# vars/networking.nix
# vars/networking.nix
{ lib }:
let
  sshDefault = {
    port = 22;
    user = "zheng";
  };

  rawHosts = {
    lz-pc.ipv4 = "100.81.104.63";
    lz-nb.ipv4 = "100.x.y.z";
    lz-vps = {
      ipv4 = "23.95.28.22";
      ssh.user = "root";
    };
    lz-vps-home.ipv4 = "23.95.28.22";
  };

  resolvedHosts = lib.mapAttrs (
    name: val:
    let
      sshConfig = sshDefault // (if val ? ssh then val.ssh else { });
    in
    {
      ipv4 = val.ipv4;
      user = sshConfig.user;
      port = sshConfig.port;
    }
  ) rawHosts;

in
{
  hostsAddr = resolvedHosts;
  sshExtraConfig = lib.attrsets.foldlAttrs (
    acc: host: val:
    acc
    + ''
      Host ${host}
        HostName ${val.ipv4}
        Port ${toString val.port}
        User ${val.user}
    ''
  ) "" resolvedHosts;
}

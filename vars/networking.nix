# vars/networking.nix
# { lib }:
# let
#   sshDefault = {
#     port = 22;
#     user = "zheng";
#   };
#
#   rawHosts = {
#     lz-pc.ipv4 = "100.81.104.63";
#     lz-nb.ipv4 = "100.x.y.z";
#     lz-vps-root = {
#       ipv4 = "23.95.28.22";
#       ssh.user = "root";
#     };
#     lz-vps.ipv4 = "23.95.28.22";
#     lz-ali.ipv4 = "47.116.41.155";
#     lz-wsl.ipv4 = "100.85.72.62";
#   };
#
#   resolvedHosts = lib.mapAttrs (
#     name: val:
#     let
#       sshConfig = sshDefault // (if val ? ssh then val.ssh else { });
#     in
#     {
#       ipv4 = val.ipv4;
#       user = sshConfig.user;
#       port = sshConfig.port;
#     }
#   ) rawHosts;
#
# in
# {
#   hostsAddr = resolvedHosts;
#   sshExtraConfig = lib.attrsets.foldlAttrs (
#     acc: host: val:
#     acc
#     + ''
#       Host ${host}
#         HostName ${val.ipv4}
#         Port ${toString val.port}
#         User ${val.user}
#     ''
#   ) "" resolvedHosts;
# }
{ lib }:
let
  sshDefault = {
    port = 22;
    user = "zheng";
  };

  rawEasytier = {
    lz-pc = {
      ipv4 = "10.126.0.10";
    };
    lz-nb = {
      ipv4 = "10.126.0.11";
    };
    lz-wsl = {
      ipv4 = "10.126.0.12";
    };
    lz-vps-root = {
      ipv4 = "10.126.0.2";
      ssh.user = "root";
    }; # 特殊用户
    lz-vps = {
      ipv4 = "10.126.0.2";
    };
    lz-ali = {
      ipv4 = "10.126.0.1";
    };
    lz-android = {
      ipv4 = "10.126.0.20";
    };
    lz-ipad = {
      ipv4 = "10.126.0.21";
    };
  };

  rawPublic = {
    lz-pc = {
      ipv4 = "100.81.104.63";
    };
    lz-vps = {
      ipv4 = "23.95.28.22";
    };
    lz-ali = {
      ipv4 = "47.116.41.155";
    };
    lz-wsl = {
      ipv4 = "100.85.72.62";
    };
  };

  resolveHosts =
    rawData:
    lib.mapAttrs (
      name: val:
      let
        customSsh = if val ? ssh then val.ssh else { };
        mergedSsh = sshDefault // customSsh;
      in
      val
      // {
        user = mergedSsh.user;
        port = mergedSsh.port;
      }
    ) rawData;

  resolvedEasytier = resolveHosts rawEasytier;
  resolvedPublic = resolveHosts rawPublic;

in
{
  hostsAddr = {
    easytier = resolvedEasytier;
    public = resolvedPublic;
  };

  sshExtraConfig = lib.attrsets.foldlAttrs (
    acc: host: val:
    acc
    + ''
      Host ${host}
        HostName ${val.ipv4}
        Port ${toString val.port}
        User ${val.user}
    ''
  ) "" resolvedEasytier;
}

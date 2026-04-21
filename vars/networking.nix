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
in
rec {
  hostsAddr.easytier = {
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
    };
    lz-vps = {
      ipv4 = "10.126.0.2";
    };
    lz-ali = {
      ipv4 = "10.126.0.1";
    };
    # 非 Nix 节点记录
    lz-android = {
      ipv4 = "10.126.0.20";
    };
    lz-ipad = {
      ipv4 = "10.126.0.21";
    };
  };

  hostsAddr.public = {
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

  ssh = {
    extraConfig = lib.attrsets.foldlAttrs (
      acc: host: val:
      let
        ssh = sshDefault // (if builtins.hasAttr "ssh" val then val.ssh else { });
      in
      acc
      + ''
        Host ${host}
          HostName ${val.ipv4}
          Port ${toString ssh.port}
          User ${ssh.user}
      ''
    ) "" hostsAddr.easytier;
  };
}

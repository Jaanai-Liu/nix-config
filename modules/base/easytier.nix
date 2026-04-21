# modules/base/easytier.nix
{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.modules.base.easytier;
in
{
  options.modules.base.easytier = {
    enable = lib.mkEnableOption "EasyTier Service";

    ipv4 = lib.mkOption {
      type = lib.types.str;
      description = "EasyTier Static Virtual IP";
    };

    networkName = lib.mkOption {
      type = lib.types.str;
      default = "zheng_net";
      description = "EasyTier Network Name";
    };

    networkSecret = lib.mkOption {
      type = lib.types.str;
      default = "Zheng_Test_2026_!@#";
      description = "EasyTier Network Secret";
    };

    peers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = "List of peers to connect to (Seed Nodes)";
    };

    listeners = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [
        "tcp://0.0.0.0:11010"
        "udp://0.0.0.0:11010"
      ];
      description = "Listeners for the node";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ pkgs.easytier ];

    systemd.services.easytier-node = {
      description = "EasyTier P2P Network Node";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = ''
          ${pkgs.easytier}/bin/easytier-core \
            --ipv4 ${cfg.ipv4} \
            --network-name "${cfg.networkName}" \
            --network-secret "${cfg.networkSecret}" \
            ${lib.concatMapStringsSep " " (l: "--listeners ${l}") cfg.listeners} \
            ${lib.concatMapStringsSep " " (p: "--peers ${p}") cfg.peers}
        '';
        Restart = "always";
        RestartSec = "5";
      };
    };

    networking.firewall = {
      allowedTCPPorts = [ 11010 ];
      allowedUDPPorts = [ 11010 ];
      trustedInterfaces = [
        "tun0"
        "easytier0"
      ];
    };
  };
}

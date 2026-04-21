# modules/base/easytier.nix
{
  config,
  lib,
  pkgs,
  myvars,
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

    # networkName = lib.mkOption {
    #   type = lib.types.str;
    #   default = "zheng_net";
    #   description = "EasyTier Network Name";
    # };

    # peers = lib.mkOption {
    #   type = lib.types.listOf lib.types.str;
    #   # default = [ myvars.networking.easytierSeed ];
    #   default = [ ];
    #   description = "List of peers to connect to (Seed Nodes)";
    # };

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

      script = ''
        SECRET=$(cat ${config.age.secrets."easytier-secret".path})
        NETWORK_NAME=$(cat ${config.age.secrets."easytier-name".path})
        PEERS_STR=$(cat ${config.age.secrets."easytier-peers".path})

        PEER_ARGS=""
        if [ -n "$PEERS_STR" ]; then
          PEER_ARGS="--peers $PEERS_STR"
        fi

        exec ${pkgs.easytier}/bin/easytier-core \
          --ipv4 ${cfg.ipv4} \
          --network-name "$NETWORK_NAME" \
          --network-secret "$SECRET" \
          ${lib.concatMapStringsSep " " (l: "--listeners ${l}") cfg.listeners} \
          $PEER_ARGS
      '';

      serviceConfig = {
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

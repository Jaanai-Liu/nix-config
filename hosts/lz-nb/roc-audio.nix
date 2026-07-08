# Bidirectional ROC audio sharing using Easytier VPN IPs from myvars.
# Source of truth: vars/networking.nix
#
# After rebuild, pavucontrol shows:
#   "ROC to lz-pc"  — send audio to desktop
#   "ROC from lz-pc" — receive desktop audio → local speakers
{ myvars, ... }:
let
  localIp = myvars.networking.hostsAddr.easytier.lz-nb.ipv4;
  remoteIp = myvars.networking.hostsAddr.easytier.lz-pc.ipv4;
in
{
  services.pipewire.extraConfig.pipewire."99-roc-network" = {
    "context.modules" = [
      # --- Receive audio FROM lz-pc ---
      {
        name = "libpipewire-module-roc-source";
        args = {
          "local.ip" = localIp;
          "local.source.port" = 10001;
          "local.repair.port" = 10002;
          "sink.name" = "roc-from-lz-pc";
          "sink.props" = {
            "node.name" = "roc-from-lz-pc";
            "node.description" = "ROC from lz-pc";
          };
        };
      }
      # --- Send audio TO lz-pc ---
      {
        name = "libpipewire-module-roc-sink";
        args = {
          "remote.ip" = remoteIp;
          "remote.source.port" = 10001;
          "remote.repair.port" = 10002;
          "sink.name" = "roc-to-lz-pc";
          "sink.props" = {
            "node.name" = "roc-to-lz-pc";
            "node.description" = "ROC to lz-pc";
          };
        };
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [ 10001 10002 ];
}

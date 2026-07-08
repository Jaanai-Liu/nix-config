# Bidirectional ROC audio sharing using Easytier VPN IPs from myvars.
# Source of truth: vars/networking.nix
#
# After rebuild, pavucontrol shows:
#   "ROC to lz-nb"  — send audio to notebook
#   "ROC from lz-nb" — receive notebook audio → local speakers
{ myvars, ... }:
let
  localIp = myvars.networking.hostsAddr.easytier.lz-pc.ipv4;
  remoteIp = myvars.networking.hostsAddr.easytier.lz-nb.ipv4;
in
{
  services.pipewire.extraConfig.pipewire."99-roc-network" = {
    "context.modules" = [
      # --- Receive audio FROM lz-nb ---
      {
        name = "libpipewire-module-roc-source";
        args = {
          "local.ip" = localIp;
          "local.source.port" = 10001;
          "local.repair.port" = 10002;
          "sink.name" = "roc-from-lz-nb";
          "sink.props" = {
            "node.name" = "roc-from-lz-nb";
            "node.description" = "ROC from lz-nb";
          };
        };
      }
      # --- Send audio TO lz-nb ---
      {
        name = "libpipewire-module-roc-sink";
        args = {
          "remote.ip" = remoteIp;
          "remote.source.port" = 10001;
          "remote.repair.port" = 10002;
          "sink.name" = "roc-to-lz-nb";
          "sink.props" = {
            "node.name" = "roc-to-lz-nb";
            "node.description" = "ROC to lz-nb";
          };
        };
      }
    ];
  };

  networking.firewall.allowedUDPPorts = [ 10001 10002 ];
}

# Bidirectional ROC audio sharing between lz-nb (10.126.0.11) and lz-pc (10.126.0.10)
#
# After rebuild, pavucontrol will show:
#   "ROC to lz-pc"     — send audio to lz-pc
#   "ROC from lz-pc"   — receive audio from lz-pc (auto-plays on local speakers)
#
# Usage: in pavucontrol, switch an app's output to "ROC to lz-pc" to play on the desktop.
#        lz-pc sends audio here → "ROC from lz-pc" → your speakers.
{ ... }:
{
  services.pipewire.extraConfig.pipewire."99-roc-network" = {
    "context.modules" = [
      # --- Receive audio FROM lz-pc ---
      {
        name = "libpipewire-module-roc-source";
        args = {
          "local.ip" = "10.126.0.11";
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
          "remote.ip" = "10.126.0.10";
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

  # Allow UDP for ROC (source port + repair port)
  networking.firewall.allowedUDPPorts = [ 10001 10002 ];
}

# Bidirectional ROC audio sharing between lz-pc (10.126.0.10) and lz-nb (10.126.0.11)
#
# After rebuild, pavucontrol will show:
#   "ROC to lz-nb"     — send audio to lz-nb
#   "ROC from lz-nb"   — receive audio from lz-nb (auto-plays on local speakers)
#
# Usage: in pavucontrol, switch an app's output to "ROC to lz-nb" to play on the notebook.
#        lz-nb sends audio here → "ROC from lz-nb" → your speakers.
{ ... }:
{
  services.pipewire.extraConfig.pipewire."99-roc-network" = {
    "context.modules" = [
      # --- Receive audio FROM lz-nb ---
      {
        name = "libpipewire-module-roc-source";
        args = {
          "local.ip" = "10.126.0.10";
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
          "remote.ip" = "10.126.0.11";
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

  # Allow UDP for ROC (source port + repair port)
  networking.firewall.allowedUDPPorts = [ 10001 10002 ];
}

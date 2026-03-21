{
  config,
  lib,
  pkgs,
  ...
}:
let
  synopsysHome = "/opt/synopsys";
  sclHome = "${synopsysHome}/scl/2024.06";
in
{
  systemd.user.services.synopsys-license = {
    Unit = {
      Description = "Synopsys License Server (lmgrd) - User Level";
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${sclHome}/linux64/bin/lmgrd -c ${sclHome}/admin/license/Synopsys.dat -z";
      ExecStopPost = "${pkgs.procps}/bin/pkill -9 snpslmd || true";
      Restart = "always";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

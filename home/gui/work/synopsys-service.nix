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
      # 网络准备好后再启动
      After = [ "network.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${sclHome}/linux64/bin/lmgrd -c ${sclHome}/admin/license/Synopsys.dat -z";
      Restart = "always";
      RestartSec = 3; # 如果意外死掉，等 3 秒再拉起，防止无限疯狂重启
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}

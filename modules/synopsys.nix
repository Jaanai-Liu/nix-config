{
  config,
  lib,
  pkgs,
  myvars,
  ...
}:

with lib;
let
  cfg = config.modules.synopsys;
in
{
  options.modules.synopsys = {
    enable = mkEnableOption "Synopsys EDA Tools System Environment";
  };

  config = mkIf cfg.enable {
    programs.nix-ld.enable = true;

    programs.nix-ld.libraries = with pkgs; [
      stdenv.cc.cc
      glibc
      zlib
      libxcrypt-legacy
      e2fsprogs
      libX11
      libXext
      libXrender
      libXrandr
      libXcursor
      libXinerama
      libXi
      libSM
      libICE
      libXt
      libXmu
      libXp
      libXtst
      libXScrnSaver
      libXft
      libxml2
      xcbutil
      xcbutilwm
      xcbutilimage
      xcbutilkeysyms
      xcbutilrenderutil
      libpng12
      ncurses5
      freetype
      libGL
      alsa-lib
      dbus
      fontconfig
      expat
      util-linux
      numactl
      libjpeg
      libtiff
      libXp
      libglvnd
    ];

    systemd.tmpfiles.rules = [
      "L+ /lib64/ld-lsb-x86-64.so.3 - - - - /lib64/ld-linux-x86-64.so.2"
    ];

    systemd.services.synopsys-license = {
      description = "Synopsys License Server (lmgrd)";
      wantedBy = [ "multi-user.target" ];
      after = [ "network-online.target" ];
      wants = [ "network-online.target" ];

      serviceConfig = {
        Type = "forking";
        User = myvars.username;
        ExecStart = "/opt/synopsys/scl/2023.09/linux64/bin/lmgrd -c /opt/synopsys/license/Synopsys.dat -l /opt/synopsys/license/lic.log";
        Restart = "on-failure";
        RestartSec = "10s";
        LimitNOFILE = 65535;
      };
    };
  };
}

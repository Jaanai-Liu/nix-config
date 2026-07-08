# XWayland HiDPI scaling for laptop (14" 2880×1800 @ 1.7x).
# xsettingsd communicates via XSETTINGS protocol — Wayland-native apps
# never read these values, so noctalia/kitty/etc. are unaffected.
{
  config,
  pkgs,
  ...
}:
{
  home.packages = [ pkgs.xsettingsd ];

  # xsettingsd config symlink — 166912 = 163 DPI × 1024 (96 × 1.7 ≈ 163)
  xdg.configFile."xsettingsd/xsettingsd.conf".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/hosts/lz-nb/scaling/xsettingsd.conf";

  # systemd user service: starts after graphical session, retries until
  # xwayland-satellite brings the X server up
  systemd.user.services.xsettingsd = {
    Unit = {
      Description = "XSETTINGS daemon for X11 DPI scaling";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.xsettingsd}/bin/xsettingsd";
      Restart = "on-failure";
      RestartSec = 3;
    };
  };
}

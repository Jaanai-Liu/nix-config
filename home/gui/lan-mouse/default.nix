# Keyboard/mouse sharing across LAN (software KVM).
# Both machines run the daemon; mDNS auto-discovers peers on the same network.
{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    lan-mouse
    xdg-desktop-portal-wlr
  ];

  systemd.user.services.lan-mouse = {
    Unit = {
      Description = "Lan Mouse — keyboard & mouse sharing daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      ExecStart = "${pkgs.lan-mouse}/bin/lan-mouse daemon";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}

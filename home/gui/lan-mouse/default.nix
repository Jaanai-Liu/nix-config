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

  xdg.configFile."lan-mouse/config.toml" = {
    text = ''
      port = 4242
      capture_backend = "LayerShell"

      [[clients]]
      hostname = "lz-nb"
      position = "left"
      activate_on_startup = true

      [authorized_fingerprints]
    '';
  };

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

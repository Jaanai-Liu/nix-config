{
  myvars,
  ...
}:
let
  remoteIp = myvars.networking.hostsAddr.easytier.lz-pc.ipv4;
in
{
  imports = [ ../../../home/gui/lan-mouse ];

  xdg.configFile."lan-mouse/config.toml".text = ''
    port = 4242
    capture_backend = "layer-shell"

    [[clients]]
    hostname = "lz-pc"
    ips = ["${remoteIp}"]
    position = "right"
    activate_on_startup = true
  '';
}

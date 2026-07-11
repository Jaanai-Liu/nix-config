{
  myvars,
  ...
}:
let
  remoteIp = myvars.networking.hostsAddr.easytier.lz-nb.ipv4;
in
{
  imports = [ ../../../home/gui/lan-mouse ];

  xdg.configFile."lan-mouse/config.toml".text = ''
    port = 4242
    capture_backend = "layer-shell"

    [[clients]]
    hostname = "lz-nb"
    ips = ["${remoteIp}"]
    position = "left"
    activate_on_startup = true
  '';
}

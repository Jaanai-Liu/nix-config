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

    [authorized_fingerprints]
    "c2:12:c4:d7:23:18:84:82:23:39:38:23:67:3f:91:62:e7:da:9d:a9:88:d2:c2:4b:0b:f8:1a:ea:37:45:91:bc" = "lz-pc"
  '';
}

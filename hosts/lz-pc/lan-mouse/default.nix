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

    [[clients]]
    hostname = "lz-nb"
    ips = ["${remoteIp}"]
    position = "left"
    activate_on_startup = true

    [authorized_fingerprints]
    "03:d3:8b:8e:4a:e0:92:ca:e7:16:19:77:63:b3:ff:5e:eb:07:f1:54:e0:12:e4:7e:1b:79:af:d2:8e:17:f0:1a" = "lz-nb"
  '';
}

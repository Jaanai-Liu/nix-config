# modules/openlist.nix
{
  config,
  pkgs,
  myvars,
  ...
}:

let
  runUser = myvars.username;
in
{
  environment.systemPackages = [ pkgs.openlist ];

  systemd.services.openlist = {
    description = "Openlist File Server Daemon";
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = runUser;

      StateDirectory = "openlist";

      ExecStart = "${pkgs.openlist}/bin/OpenList server --data /var/lib/openlist";

      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}

{
  config,
  pkgs,
  myvars,
  ...
}:

let
  username = myvars.username;
  mountPath = "/mnt/openlist";
  configPath = config.age.secrets."rclone-openlist".path;
in
{
  programs.fuse.userAllowOther = true;

  environment.systemPackages = [
    pkgs.rclone
    pkgs.fuse
  ];

  systemd.services.rclone-openlist-mount = {
    description = "Rclone mount Openlist WebDAV to ${mountPath}";
    after = [
      "network-online.target"
      "openlist.service"
    ];
    wants = [ "network-online.target" ];
    requires = [ "openlist.service" ];
    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      User = username;

      Environment = "PATH=/run/wrappers/bin:/run/current-system/sw/bin:${pkgs.coreutils}/bin";

      ExecStartPre = [
        "+${pkgs.coreutils}/bin/mkdir -p ${mountPath}"
        "+${pkgs.coreutils}/bin/chown ${username}:users ${mountPath}"
      ];

      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount openlist:/ ${mountPath} \
          --config ${configPath} \
          --vfs-cache-mode full \
          --vfs-cache-max-age 24h \
          --vfs-cache-max-size 10G \
          --header "Referer:" \
          --vfs-read-chunk-size 128M \
          --buffer-size 32M \
          --allow-other
      '';

      ExecStop = "/run/wrappers/bin/fusermount3 -u ${mountPath}";

      Restart = "on-failure";
      RestartSec = "15s";
    };
  };
}

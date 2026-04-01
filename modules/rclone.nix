{
  config,
  pkgs,
  myvars,
  ...
}:

let
  username = myvars.username;
  mountPath = "/mnt/alist";
  configPath = config.age.secrets."rclone-alist".path;
in
{
  programs.fuse.userAllowOther = true;

  environment.systemPackages = [
    pkgs.rclone
    pkgs.fuse
  ];

  systemd.services.rclone-alist-mount = {
    description = "Rclone mount Alist WebDAV to ${mountPath}";
    after = [
      "network-online.target"
      "alist.service"
    ];
    requires = [ "alist.service" ];
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
        ${pkgs.rclone}/bin/rclone mount alist:/ ${mountPath} \
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

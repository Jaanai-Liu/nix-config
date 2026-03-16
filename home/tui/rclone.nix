{ pkgs, ... }:
{
  home.packages = [
    pkgs.rclone
  ];

  home.activation.createMountDir = ''
    mkdir -p %h/alist
  '';

  systemd.user.services.rclone-mount-alist = {
    Unit = {
      Description = "rclone mount alist webdav to home directory";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount alist:/ %h/alist \
          --vfs-cache-mode full \
          --vfs-cache-max-age 24h \
          --vfs-cache-max-size 10G \
          --header "Referer:" \
          --vfs-read-chunk-size 128M \
          --buffer-size 32M \
          --allow-other
      '';
      ExecStop = "${pkgs.fuse}/bin/fusermount -u %h/alist";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}

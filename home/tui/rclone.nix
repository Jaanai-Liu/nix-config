{ pkgs, ... }: {
  home.packages = [ 
    pkgs.rclone 
  ];
  # 确保挂载点目录存在
  home.activation.createMountDir = ''
    mkdir -p %h/mnt/alist
  '';

  systemd.user.services.rclone-mount-alist = {
    Unit = {
      Description = "rclone mount alist webdav";
      After = [ "network-online.target" ];
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount alist:/ %h/mnt/alist \
          --vfs-cache-mode full \
          --vfs-cache-max-age 24h \
          --vfs-cache-max-size 10G \
          --header "Referer:" \
          --vfs-read-chunk-size 128M \
          --vfs-read-chunk-size-limit off \
          --buffer-size 32M
      '';
      ExecStop = "/run/current-system/sw/bin/fusermount -u %h/mnt/alist";
      Restart = "on-failure";
      RestartSec = "10s";
    };
  };
}
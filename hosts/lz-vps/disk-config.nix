# hosts/lz-vps/disk-config.nix
{
  disko.devices = {
    disk = {
      vda = {
        type = "disk";
        device = "/dev/vda";
        content = {
          type = "gpt";
          partitions = {
            # 兼容老式 BIOS 启动 (RackNerd 很多机器默认是这个)
            boot = {
              size = "1M";
              type = "EF02";
            };
            # 兼容现代 UEFI 启动
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };
            # 根目录 (剩下的所有空间都给它)
            root = {
              size = "100%";
              content = {
                type = "filesystem";
                format = "ext4";
                mountpoint = "/";
              };
            };
          };
        };
      };
    };
  };
}

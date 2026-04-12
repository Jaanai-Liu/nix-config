# hosts/lz-pc/disk-config.nix
{
  disko.devices = {
    nodev."/" = {
      fsType = "tmpfs";
      mountOptions = [
        "size=4G"
        "relatime"
        "mode=755"
      ];
    };

    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              priority = 1;
              name = "ESP";
              start = "1M";
              end = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
            swap = {
              size = "32G";
              content = {
                type = "swap";
                resumeDevice = true;
              };
            };
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ];
                subvolumes = {
                  "/" = {
                    mountpoint = "/btr_pool";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/@btrbk_archive" = {
                    mountpoint = "/btrbk_archive";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  # "/@root" = {
                  #   mountpoint = "/";
                  #   mountOptions = [
                  #     "compress=zstd"
                  #     "noatime"
                  #   ];
                  # };
                  "/@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                  "/@persistent" = {
                    mountpoint = "/persistent";
                    mountOptions = [
                      "compress=zstd"
                      "noatime"
                    ];
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

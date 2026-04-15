# modules/base/btrbk.nix
{
  config,
  lib,
  myvars,
  pkgs,
  ...
}:
let
  cfg = config.modules.btrbk;
in
{
  options.modules.btrbk = {
    enable = lib.mkEnableOption "Btrbk Backup System";

    role = lib.mkOption {
      type = lib.types.enum [
        "server"
        "workstation"
      ];
      default = "workstation";
      description = ''
        Machine role in the backup topology:
        - server: Creates local snapshots only.
        - workstation: Creates local backups AND pulls remote backups from servers.
      '';
    };
  };
  # ==================================================================
  # Btrbk configuration for single-disk setup
  # Logic: Creates local snapshots and stores "backups" in a separate
  # subvolume on the same physical drive.

  # Usage:
  #   1. btrbk will create snapshots on schedule
  #   2. we can use `btrbk run` command to create a backup manually

  # How to restore a snapshot:
  #   1. Find the snapshot you want to restore in /snapshots
  #   2. Use `btrfs subvol delete /btr_pool/@persistent` to delete the current subvolume
  #   3. Use `btrfs subvol snapshot /snapshots/2021-01-01 /btr_pool/@persistent` to restore the snapshot
  #   4. reboot the system or remount the filesystem to see the changes
  #
  # ==================================================================

  config = lib.mkIf cfg.enable (
    lib.mkMerge [

      # ------------------ Server Role ------------------ #
      (lib.mkIf (cfg.role == "server") {
        services.btrbk.instances.btrbk = {
          onCalendar = "daily";
          settings = {
            snapshot_preserve = "3d";
            snapshot_preserve_min = "1d";
            target_preserve = "no";
            target_preserve_min = "no";

            volume."/btr_pool" = {
              snapshot_dir = "@snapshots";
              subvolume."@" = { };
              subvolume."@home" = { };
            };
          };
        };
        # systemd.tmpfiles.rules = [
        #   "d /.btrbk_snapshots 0700 root root -"
        # ];
      })

      # ------------------ Workstation Role ------------------ #
      (lib.mkIf (cfg.role == "workstation") {
        services.btrbk.instances.btrbk = {
          # Changed schedule to Tuesday and Saturday at 11:00 PM
          onCalendar = "Tue,Sat *-*-* 23:00:00";

          settings = {
            # Local snapshot retention policy (Source side)
            snapshot_preserve = "7d";
            snapshot_preserve_min = "2d";

            # Local "backup" retention policy (Target side on the same disk)
            # Since it is the same disk, this provides version history
            target_preserve = "9d 4w 2m";
            target_preserve_min = "no";

            # sudo btrfs
            backend = "btrfs-progs-sudo";

            volume = {
              # Assuming your Btrfs root is mounted at "/"
              "/btr_pool" = {
                # Directory where short-term snapshots are temporarily stored
                snapshot_dir = "@snapshots";

                subvolume = {
                  # Backing up your home directory (Thesis, BP Neural Network code, etc.)

                  # "home" = {
                  #   snapshot_create = "always";
                  # };

                  # "@root" = {
                  #   snapshot_create = "always";
                  # };
                  # "@nix" = {
                  #   snapshot_create = "always";
                  # };
                  "@persistent" = {
                    snapshot_create = "always";
                  };
                };

                # Since you have only one drive, the target is a local path.
                # You should create this subvolume first: sudo btrfs subvolume create /btrbk_archive
                target = "/snapshots/local";
              };
              "ssh://lz-vps/btr_pool" = {
                snapshot_dir = "@snapshots";
                subvolume."@" = { };
                subvolume."@home" = { };
                target = "/snapshots/lz-vps";
                ssh_identity = "/home/${myvars.username}/.ssh/id_ed25519";
              };
            };
          };
        };
      })
    ]
  );
}

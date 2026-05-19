{
  inputs,
  lib,
  pkgs,
  myvars,
  ...
}:
let
  username = myvars.username;
in
{
  imports = [
    inputs.preservation.nixosModules.default
  ];

  preservation.enable = true;
  boot.initrd.systemd.enable = true;

  environment.systemPackages = [
    pkgs.ncdu
  ];

  preservation.preserveAt."/persistent" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/etc/nix/inputs"
      "/etc/secureboot"

      "/etc/agenix/"
      "/var/log"
      "/var/cache/davfs2"

      {
        directory = "/var/cache/tuigreet";
        user = "greeter";
        group = "greeter";
        mode = "0755";
      }

      "/var/lib/nixos"
      "/var/lib/systemd"
      {
        directory = "/var/lib/private";
        mode = "0700";
      }

      "/opt"
      "/var/lib/cni"
      "/var/lib/containers"
      "/var/lib/flatpak"
      "/var/lib/libvirt"
      "/var/lib/lxc"
      "/var/lib/lxd"
      "/var/lib/qemu"

      "/var/lib/bluetooth"
      "/var/lib/NetworkManager"
      "/var/lib/iwd"
      "/var/lib/tailscale"

      {
        directory = "/var/lib/openlist";
        user = username;
        group = "users";
        mode = "0700";
      }
    ];
    files = [
      {
        file = "/etc/machine-id";
        inInitrd = true;
      }
    ];

    users.${username} = {
      commonMountOptions = [ "x-gvfs-hide" ];

      directories = [
        "Desktop"
        "Downloads"
        "Documents"
        "Music"
        "Pictures"
        "Videos"
        ".cache"
        "work"
        "projects"
        "nix-config"
        "tmp"
        ".local/share/direnv"
        ".local/state/nix"
        ".local/share/nix"
        ".local/state/home-manager"
        ".config/zsh"
        ".config/fcitx5"
        ".local/share/fcitx5"
        ".gnupg"
        ".ssh"
        ".npm"
        ".cargo"
        ".m2"
        ".gradle"
        "go"
        ".local/pipx"
        ".local/bin"
        ".local/share/uv"
        {
          directory = ".var";
          mode = "0700";
        }
        ".claude"
        ".config/claude"
        ".mozilla"
        ".config/google-chrome"
        ".local/share/containers"
        ".local/share/flatpak"
        ".config/pulse"
        ".local/state/wireplumber"
      ];
    };
  };

  systemd.tmpfiles.settings.preservation =
    let
      permission = {
        user = username;
        group = lib.mkForce "users";
        mode = lib.mkForce "0750";
      };
    in
    {
      "/home/${username}/.config".d = permission;
      "/home/${username}/.local".d = permission;
      "/home/${username}/.local/share".d = permission;
      "/home/${username}/.local/state".d = permission;
      "/home/${username}/.local/state/nix".d = permission;
    };

  systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];

  systemd.services.systemd-machine-id-commit = {
    unitConfig.ConditionPathIsMountPoint = [
      ""
      "/persistent/etc/machine-id"
    ];
    serviceConfig.ExecStart = [
      ""
      "systemd-machine-id-setup --commit --root /persistent"
    ];
  };
}

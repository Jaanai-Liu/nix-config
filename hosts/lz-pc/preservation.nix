{
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # 假设你的用户名是 zheng，如果不是请替换
  username = "zheng";
in
{
  imports = [
    inputs.preservation.nixosModules.default
  ];

  preservation.enable = true;
  boot.initrd.systemd.enable = true;

  environment.systemPackages = [ pkgs.ncdu ];

  preservation.preserveAt."/persistent" = {
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/ssh"
      "/var/log"
      "/var/lib/nixos"
      "/var/lib/systemd"
      "/var/lib/bluetooth"
    ];
    files = [
      {
        file = "/etc/machine-id";
        inInitrd = true;
      }
    ];

    users.${username} = {
      directories = [
        "Desktop"
        "Downloads"
        "Documents"
        "Music"
        "Pictures"
        "Videos"

        "nix-config"
        ".ssh"
        ".gnupg"
        ".local/share/keyrings"
        "projects"

        ".cache"
        ".local/state/home-manager"
        ".local/state/nix"
        ".local/share/nix"

        ".local/share/Steam"
        ".steam"
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
      "/home/${username}/.local".d = permission;
      "/home/${username}/.local/share".d = permission;
      "/home/${username}/.local/state".d = permission;
      "/home/${username}/.config".d = permission;
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

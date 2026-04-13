{
  pkgs,
  config,
  lib,
  mylib,
  ...
}@args:
let
  cfg = config.home.desktop.niri;
in
{
  options.home.desktop.niri = {
    enable = lib.mkEnableOption "niri compositor";
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        home.packages = with pkgs; [
          # Niri v25.08 will create X11 sockets on disk, export $DISPLAY, and spawn `xwayland-satellite` on-demand when an X11 client connects
          xwayland-satellite
          # kdePackages.polkit-kde-agent-1
        ];

        xdg.configFile =
          let
            mkSymlink = config.lib.file.mkOutOfStoreSymlink;
            confPath = "${config.home.homeDirectory}/nix-config/home/gui/desktop/niri/conf";
          in
          {
            "niri/config.kdl".source = mkSymlink "${confPath}/config.kdl";
            "niri/keybindings.kdl".source = mkSymlink "${confPath}/keybindings.kdl";
            "niri/noctalia-shell.kdl".source = mkSymlink "${confPath}/noctalia-shell.kdl";
            "niri/spawn-at-startup.kdl".source = mkSymlink "${confPath}/spawn-at-startup.kdl";
            "niri/windowrules.kdl".source = mkSymlink "${confPath}/windowrules.kdl";
          };

        systemd.user.services.niri-flake-polkit = {
          Unit = {
            Description = "PolicyKit Authentication Agent provided by niri-config";
            After = [ "graphical-session.target" ];
            Wants = [ "graphical-session-pre.target" ];
          };
          Install.WantedBy = [ "niri.service" ];
          Service = {
            Type = "simple";
            ExecStart = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
            Restart = "on-failure";
            RestartSec = 1;
            TimeoutStopSec = 10;
          };
        };

        # NOTE: this executable is used by greetd to start a wayland session when system boot up
        # with such a vendor-no-locking script, we can switch to another wayland compositor without modifying greetd's config in NixOS module
        home.file.".wayland-session" = {
          executable = true;
          text = ''
            #!/bin/sh
            # dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=niri
            # trying to stop a previous niri session
            systemctl --user is-active niri.service && systemctl --user stop niri.service
            # and then we start a new one
            # exec /run/current-system/sw/bin/niri-session
            /run/current-system/sw/bin/niri-session
          '';
        };
      }
    ]
  );
}

{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.home.tui.mail;
  mail-scripts = pkgs.mkScriptsPackage "mail-scripts" ./scripts;
in
{
  options.home.tui.mail = {
    enable = lib.mkEnableOption "TUI Mail setup";
  };

  imports = [
    ./accounts.nix
    ./aerc
    ./offlineimap
    ./imapnotify
  ];

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      mail-scripts
      libnotify
      pulseaudio
    ];
  };
}

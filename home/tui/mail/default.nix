{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.home.tui.mail;
  secretPath = "${config.xdg.configHome}/mail-secrets";
in
{
  options.home.tui.mail = {
    enable = lib.mkEnableOption "Enable mail client (aerc + offlineimap)";
  };

  imports = [
    ./aerc
    ./offlineimap
    ./imapnotify
  ];

  config = lib.mkIf cfg.enable {
    # home.packages = [
    #   (pkgs.mkScriptsPackage "mail-scripts" ./scripts)
    # ];
    accounts.email.accounts = {

      "Gmail" = {
        primary = true;
        address = "liujaanai@gmail.com";
        userName = "liujaanai@gmail.com";
        realName = "Zheng Liu";
        passwordCommand = "${pkgs.coreutils}/bin/cat ${secretPath}/gmail";
        imap.host = "imap.gmail.com";
        imap.port = 993;
        smtp.host = "smtp.gmail.com";
        smtp.port = 465;
      };
    };
  };
}

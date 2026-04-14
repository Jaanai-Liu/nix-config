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
    # ./imapnotify
    # ./mbsync
    ./himalaya
  ];

  config = lib.mkIf cfg.enable {
    accounts.email.maildirBasePath = "Mail";

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

      "QQ" = {
        address = "1528588293@qq.com";
        userName = "1528588293@qq.com";
        realName = "Zheng Liu";
        passwordCommand = "${pkgs.coreutils}/bin/cat ${secretPath}/qq";
        imap.host = "imap.qq.com";
        imap.port = 993;
        smtp.host = "smtp.qq.com";
        smtp.port = 465;
      };

      # "163" = {
      #   address = "liuzheng2502@163.com";
      #   userName = "liuzheng2502@163.com";
      #   realName = "Zheng Liu";
      #   passwordCommand = "${pkgs.coreutils}/bin/cat ${secretPath}/163";
      #   imap.host = "imap.163.com";
      #   imap.port = 993;
      #   smtp.host = "smtp.163.com";
      #   smtp.port = 465;
      # };

      # "SWJTU" = {
      #   address = "liuzheng2502@my.swjtu.edu.cn";
      #   userName = "liuzheng2502@my.swjtu.edu.cn";
      #   realName = "Zheng Liu";
      #   passwordCommand = "${pkgs.coreutils}/bin/cat ${secretPath}/swjtu";
      #   imap.host = "imap.my.swjtu.edu.cn";
      #   # imap.host = "imap.coremail.cn";
      #   imap.port = 993;
      #   smtp.host = "smtp.my.swjtu.edu.cn";
      #   # smtp.host = "smtp.coremail.cn";
      #   smtp.port = 465;
      # };
    };
  };
}

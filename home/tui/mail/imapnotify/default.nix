{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.home.tui.mail;

  notifyCmd =
    account:
    "mbsync ${account} && ${pkgs.libnotify}/bin/notify-send -u normal -a 'Mail' '📥 New Mail Notify' '${account} mail receive new message！'";
in
{
  config = lib.mkIf cfg.enable {

    services.imapnotify.enable = true;

    accounts.email.accounts = {
      "Gmail".imapnotify = {
        enable = true;
        boxes = [ "INBOX" ];
        onNotify = notifyCmd "Gmail";
      };
      "QQ".imapnotify = {
        enable = true;
        boxes = [ "INBOX" ];
        onNotify = notifyCmd "QQ";
      };
      "163".imapnotify = {
        enable = true;
        boxes = [ "INBOX" ];
        onNotify = notifyCmd "163";
      };
      "SWJTU".imapnotify = {
        enable = true;
        boxes = [ "INBOX" ];
        onNotify = notifyCmd "SWJTU";
      };
    };
  };
}

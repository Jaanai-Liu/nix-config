{ config, lib, ... }:
let
  cfg = config.home.tui.mail;
in
{
  config = lib.mkIf cfg.enable {
    programs.mbsync.enable = true;

    accounts.email.accounts = {
      "Gmail".mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
        patterns = [
          "INBOX"
          "[Gmail]/Sent Mail"
          "[Gmail]/Drafts"
          "[Gmail]/Trash"
          "[Gmail]/Spam"
          "[Gmail]/Starred"
          "[Gmail]/Important"
        ];
      };
      "QQ".mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };
      "163".mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };
      "SWJTU".mbsync = {
        enable = true;
        create = "both";
        expunge = "both";
      };
    };
  };
}

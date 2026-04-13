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
      };
      # "QQ".mbsync = { enable = true; create = "both"; expunge = "both"; };
      # "163".mbsync = { enable = true; create = "both"; expunge = "both"; };
      # "SWJTU".mbsync = { enable = true; create = "both"; expunge = "both"; };
    };
  };
}

{ config, lib, ... }:
let
  cfg = config.home.tui.mail;
in
{
  config = lib.mkIf cfg.enable {
    programs.himalaya.enable = true;

    accounts.email.accounts = {
      "Gmail".himalaya.enable = true;
      "QQ".himalaya.enable = true;
      "163".himalaya.enable = true;
      "SWJTU".himalaya.enable = true;
    };
  };
}

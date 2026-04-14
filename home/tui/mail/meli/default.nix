{ config, lib, ... }:

let
  cfg = config.home.tui.mail;
in
{
  config = lib.mkIf cfg.enable {
    programs.meli = {
      enable = true;
      settings = {
        terminal = {
          notifications = true;
        };
      };
    };
  };
}

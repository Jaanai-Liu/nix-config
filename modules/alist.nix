# modules/alist.nix
{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    alist
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "alist-${pkgs.alist.version}"
  ];

  # 定义alist后台服务
  systemd.user.services.alist = {
    description = "Alist file server";
    after = [ "network.target" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/.local/share/alist";
      ExecStart = "${pkgs.alist}/bin/alist server --data %h/.local/share/alist";
      # WorkingDirectory = "%h";
      Restart = "on-failure";
      RestartSec = "5s";
      # ProtectSystem = "full";
    };
  };
}

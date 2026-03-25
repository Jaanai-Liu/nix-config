{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    v2rayn
  ];

  # services.v2rayn.enable = true;

  # 3. 这里的端口建议放行（如果你需要从局域网访问）
  # networking.firewall.allowedTCPPorts = [ 2017 ];
}

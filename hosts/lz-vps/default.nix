# hosts/lz-vps/default.nix
{
  myvars,
  config,
  pkgs,
  modulesPath,
  disko,
  ...
}:

{
  imports = [
    disko.nixosModules.disko
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
    ../../secrets/nixos.nix
    ../../modules/core/nix.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "/dev/vda";
  };

  networking.hostName = "lz-vps";
  time.timeZone = "Asia/Shanghai";

  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;

  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  environment.systemPackages = with pkgs; [
    wget
    curl
    git
  ];

  users.users.root = {
    openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
  };

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
    settings.PasswordAuthentication = false;
  };

  networking.firewall.allowedTCPPorts = [ 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ];

  modules.secrets.server.proxy.enable = true;
  services.sing-box = {
    enable = true;
    settings = {
      inbounds = [
        {
          type = "vless";
          tag = "vless-in";
          listen = "::";
          listen_port = 443;
          users = [
            {
              uuid._secret = config.age.secrets."sing-box-uuid".path;
              flow = "xtls-rprx-vision";
            }
          ];
          tls = {
            enabled = true;
            server_name = "www.microsoft.com";
            reality = {
              enabled = true;
              handshake = {
                server = "www.microsoft.com";
                server_port = 443;
              };
              private_key._secret = config.age.secrets."sing-box-private-key".path;
              short_id = [
                { _secret = config.age.secrets."sing-box-short-id".path; }
              ];
            };
          };
        }
      ];
      outbounds = [
        {
          type = "direct";
          tag = "direct";
        }
      ];
    };
  };

  system.stateVersion = "25.11";
}

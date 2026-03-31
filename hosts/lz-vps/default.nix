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
    ../../modules/core/ssh.nix
  ];

  modules.core.ssh.harden = true;

  programs.zsh.enable = true;
  users.users.${myvars.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
    # openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
  };

  home-manager.users.${myvars.username} = {
    programs.home-manager.enable = true;
    home.username = myvars.username;
    home.homeDirectory = "/home/${myvars.username}";
    # fonts.fontconfig.enable = true;
    home.stateVersion = "25.11";
    imports = [
      ../../home/base/shells/zsh.nix
    ];
  };

  nix.settings.trusted-users = [
    "root"
    "@wheel"
    myvars.username
  ];

  security.sudo.extraRules = [
    {
      users = [ myvars.username ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
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

  # services.openssh = {
  #   enable = true;
  #   settings.PermitRootLogin = "prohibit-password";
  #   settings.PasswordAuthentication = false;
  # };

  networking.firewall.allowedTCPPorts = [
    22
    443
  ];
  networking.firewall.allowedUDPPorts = [
    443
    8443
  ];

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
        # {
        #   type = "shadowsocks";
        #   tag = "ss-udp-in";
        #   listen = "::";
        #   listen_port = 8443;
        #   method = "2022-blake3-aes-128-gcm";
        #   password._secret = config.age.secrets."sing-box-hy2-pass".path;
        # }
        {
          type = "hysteria2";
          tag = "hy2-in";
          listen = "::";
          listen_port = 443;
          users = [
            {
              password._secret = config.age.secrets."sing-box-hy2-pass".path;
            }
          ];
          tls = {
            enabled = true;
            certificate_path = "/var/lib/sing-box/cert.pem";
            key_path = "/var/lib/sing-box/key.pem";
          };
          obfs = {
            type = "salamander";
            # password._secret = config.age.secrets."sing-box-uuid".path;
            password = "a1418405-712a-4a36-9772-8ba589aeb40b";
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

  # 自动生成自签名证书（防止因缺文件导致启动失败）
  systemd.services.sing-box.preStart = ''
    if [ ! -f /var/lib/sing-box/cert.pem ]; then
      ${pkgs.openssl}/bin/openssl req -x509 -newkey rsa:2048 -keyout /var/lib/sing-box/key.pem -out /var/lib/sing-box/cert.pem -sha256 -days 3650 -nodes -subj "/CN=www.microsoft.com"
      chown sing-box:sing-box /var/lib/sing-box/*.pem
    fi
  '';

  system.stateVersion = "25.11";
}

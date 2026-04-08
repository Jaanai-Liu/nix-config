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
    ../../modules/server/sing-box.nix
  ];

  programs.zsh.enable = true;
  users.users.${myvars.username} = {
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "wheel" ];
  };

  # home-manager.users.${myvars.username} = {
  #   programs.home-manager.enable = true;
  #   home.username = myvars.username;
  #   home.homeDirectory = "/home/${myvars.username}";
  #   # fonts.fontconfig.enable = true;
  #   home.stateVersion = "25.11";
  #   imports = [
  #     ../../home/base/shells/zsh.nix
  #   ];
  # };

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

  system.stateVersion = "25.11";
}

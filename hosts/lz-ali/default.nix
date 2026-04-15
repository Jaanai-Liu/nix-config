# hosts/lz-ali/default.nix
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
    ../../modules/base
    ../../modules/server
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    efiInstallAsRemovable = true;
    device = "/dev/vda";
  };

  networking.hostName = "lz-ali";

  zramSwap.enable = true;
  zramSwap.memoryPercent = 100;

  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "fq";
    "net.ipv4.tcp_congestion_control" = "bbr";
  };

  system.stateVersion = "25.11";
}

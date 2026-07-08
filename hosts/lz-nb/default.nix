{
  config,
  pkgs,
  myvars,
  mysecrets,
  inputs,
  ...
}:

{
  imports = [
    inputs.disko.nixosModules.disko

    ./hardware-configuration.nix
    ./disk-config.nix
    ./preservation.nix
    ./hardware
    ./roc-audio.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Power management
  powerManagement.enable = true;

  # Hostname
  networking.hostName = "lz-nb";

  # AMD iGPU (Radeon 780M)
  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.graphics.enable = true;

  system.stateVersion = "25.11";
}

{
  config,
  pkgs,
  myvars,
  ...
}:

{
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      runAsRoot = true;
      swtpm.enable = true; # 支持 TPM 2.0 (装 Win11 可能会用到)
    };
  };

  programs.virt-manager.enable = true;

  programs.dconf.enable = true;

  users.users.${myvars.username}.extraGroups = [
    "libvirtd"
    "kvm"
  ];

  environment.systemPackages = with pkgs; [
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    linux-firmware
  ];
}

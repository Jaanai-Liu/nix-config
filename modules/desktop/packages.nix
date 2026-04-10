{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    fastfetch
    tree

    # archives
    zip
    xz
    zstd
    unzip
    unzipNLS
    p7zip
    gnutar

    glib
    strace

    # system tools
    lm_sensors # for `sensors` command
    pciutils # lspci
    usbutils # lsusb
    parted
    nvtopPackages.amd

    # ventoy

    protontricks
  ];
}

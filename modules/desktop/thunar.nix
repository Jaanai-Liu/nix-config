{
  lib,
  pkgs,
  ...
}:
{
  security.sudo.keepTerminfo = true;

  environment.systemPackages = with pkgs; [
    gnumake
    wl-clipboard
  ];

  services = {
    gvfs.enable = true;
    udisks2.enable = true;
    tumbler.enable = true;
  };

  programs = {
    dconf.enable = true;
    thunar = {
      enable = true;
      plugins = with pkgs; [
        thunar-archive-plugin
        thunar-volman
      ];
    };
  };
}

{ pkgs, ... }:

{
  programs.fuse.userAllowOther = true;

  environment.systemPackages = with pkgs; [
    fuse
    fuse3
  ];

  boot.kernelModules = [ "fuse" ];
}

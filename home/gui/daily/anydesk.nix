
# modules/yazi.nix
{ config, pkgs, ... }:
{
    home.packages = with pkgs; [
      anydesk
    ];
}

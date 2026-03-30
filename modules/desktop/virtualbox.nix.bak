{ config, pkgs, myvars, ... }:

{
  virtualisation.virtualbox.host = {
    enable = true;
    enableExtensionPack = true; 
  };
  users.users.${myvars.username}.extraGroups = [ "vboxusers" ];
}

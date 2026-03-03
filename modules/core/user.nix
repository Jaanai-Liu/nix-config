{ config, pkgs, myvars, ... }:
{
  programs.zsh.enable = true;

  users.users.${myvars.username} = {
    inherit (myvars) initialHashedPassword;
    home = "/home/${myvars.username}";
    isNormalUser = true;
    description = myvars.userfullname;
    #加入了dialout和tty方便硬件调试
    extraGroups = [ "networkmanager" "wheel" "video" "audio" "docker" "dialout" "tty" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
  };

  #root用户的SSH公钥保持同步
  users.users.root = {
    inherit (myvars) initialHashedPassword;
    openssh.authorizedKeys.keys = config.users.users."${myvars.username}".openssh.authorizedKeys.keys;
  };
  
}
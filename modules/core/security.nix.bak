{
  pkgs,
  lib,
  myvars,
  ...
}:
{
  security.sudo = {
    enable = true;
    keepTerminfo = true;
    extraRules = [
      {
        users = [ "${myvars.username}" ];
        commands = [
          {
            command = "ALL";
            options = [ "NOPASSWD" ];
          }
        ];
      }
    ];
  };

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.fuse.userAllowOther = true;
}

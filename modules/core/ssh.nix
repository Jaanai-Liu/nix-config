{
  config,
  pkgs,
  lib,
  myvars,
  ...
}:
let
  cfg = config.modules.core.ssh;
in
{
  options.modules.core.ssh.harden = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "是否开启 SSH 安全加固（禁用密码登录）";
  };

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  # services.openssh = {
  #   enable = true;
  #   settings = {
  #     X11Forwarding = true;
  #     # PasswordAuthentication = false;
  #   };
  # };
  config = {
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PasswordAuthentication = lib.mkIf cfg.harden false;
        PermitRootLogin = if cfg.harden then "prohibit-password" else "yes";
      };
    };

    users.users."${myvars.username}" = {
      description = myvars.userfullname;
      openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
    };

    security.polkit.enable = true;
    programs.ssh.setXAuthLocation = true;
    programs.ssh.extraConfig = myvars.networking.sshExtraConfig;
  };
}

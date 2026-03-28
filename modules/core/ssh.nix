{
  config,
  pkgs,
  libs,
  myvars,
  ...
}:
{
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      X11Forwarding = true;
      # PasswordAuthentication = false;
    };
  };

  users.users."${myvars.username}" = {
    description = myvars.userfullname;
    openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
  };

  security.polkit.enable = true;

  programs.ssh.setXAuthLocation = true;
  programs.ssh.extraConfig = myvars.networking.sshExtraConfig;
}

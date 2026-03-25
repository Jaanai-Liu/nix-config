{
  config,
  pkgs,
  myvars,
  ...
}:
{
  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;
  services.openssh = {
    enable = true;
    settings = {
      # 允许 X11 图形界面转发
      X11Forwarding = true;
    };
  };

  programs.ssh.setXAuthLocation = true;

  programs.ssh.extraConfig = myvars.networking.sshExtraConfig;
}


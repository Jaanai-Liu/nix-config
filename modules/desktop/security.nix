{
  pkgs,
  lib,
  myvars,
  ...
}:
{
  # security.sudo = {
  #   enable = true;
  #   keepTerminfo = true;
  #   extraRules = [
  #     {
  #       users = [ "${myvars.username}" ];
  #       commands = [
  #         {
  #           command = "ALL";
  #           options = [ "NOPASSWD" ];
  #         }
  #       ];
  #     }
  #   ];
  # };

  # security with polkit
  security.polkit.enable = true;
  # security with gnome-kering
  services.gnome = {
    gnome-keyring.enable = true;
    # Use gnome keyring's SSH Agent
    # https://wiki.gnome.org/Projects/GnomeKeyring/Ssh
    gcr-ssh-agent.enable = false;
  };
  # seahorse is a GUI App for GNOME Keyring.
  programs.seahorse.enable = true;
  # The OpenSSH agent remembers private keys for you
  # so that you don’t have to type in passphrases every time you make an SSH connection.
  # Use `ssh-add` to add a key to the agent.
  programs.ssh.startAgent = true;
  security.pam.services.greetd.enableGnomeKeyring = true;

  # gpg agent with pinentry
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    enableSSHSupport = false;
    settings.default-cache-ttl = 4 * 60 * 60; # 4 hours
  };

  # programs.fuse.userAllowOther = true;

  security.wrappers.quickshell = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${pkgs.quickshell}/bin/quickshell"; # 如果报错说找不到包，可能要改成你的 input 路径
  };
}

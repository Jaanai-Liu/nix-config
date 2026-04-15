# modules/server/security.nix
{
  myvars,
  ...
}:
{
  nix.settings.trusted-users = [
    "root"
    "@wheel"
    myvars.username
  ];

  security.sudo.extraRules = [
    {
      users = [ myvars.username ];
      commands = [
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  users.users.root = {
    openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
  };
}

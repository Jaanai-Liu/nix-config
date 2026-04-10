# hosts/lz-wsl/default.nix
{
  inputs,
  myvars,
  config,
  pkgs,
  ...
}:

{
  imports = [
    ./nix-ld.nix
    ../../secrets/nixos.nix
    ../../modules/base
    ../../modules/desktop/networking/tailscale.nix
  ];

  # Enable NixOS-WSL integration
  wsl.enable = true;
  wsl.defaultUser = myvars.username;

  nix.settings.trusted-users = [
    "root"
    "@wheel"
    myvars.username
  ];

  # Preserve NOPASSWD for sudo operations
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

  networking.hostName = "lz-wsl";

  users.users.root = {
    openssh.authorizedKeys.keys = myvars.sshAuthorizedKeys;
  };

  system.stateVersion = "25.11";
}

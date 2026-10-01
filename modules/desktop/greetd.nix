{
  pkgs,
  inputs,
  myvars,
  lib,
  ...
}:
let
  noctalia-greeter-pkg = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # noctalia-greeter-pkg = pkgs.noctalia-greeter;
in
{
  imports = [
    inputs.noctalia-greeter.nixosModules.default
  ];

  security.pam.services.greetd.enableGnomeKeyring = true;
  services.displayManager.gdm.enable = false;
  services.gnome.gnome-keyring.enable = true;

  services.displayManager.noctalia-greeter = {
    enable = true;
    package = noctalia-greeter-pkg;
    passwordless-sync-users = [ myvars.username ];
    settings = {
      user.default = myvars.username;
      session.default = "Niri";
      cursor.size = 24;
    };
  };

  services.greetd.settings.default_session.user = "greeter";
}

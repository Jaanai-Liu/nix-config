# colmena - Remote Deployment via SSH
# New-style helper: accepts and passes through deployment params so that
# per-host overrides (targetHost / targetUser / targetPort /
# privilegeEscalationCommand) actually take effect.
{
  lib,
  inputs,
  nixos-modules,
  home-modules ? [ ],
  myvars,
  system,
  tags,
  targetHost ? null,
  targetUser ? null,
  targetPort ? null,
  privilegeEscalationCommand ? null,
  genSpecialArgs,
  specialArgs ? (genSpecialArgs system),
  mymodules ? { },
  myhome ? { },
  ...
}:
let
  inherit (inputs) home-manager;
  spArgs = specialArgs // {
    inherit mymodules myhome;
  };
in
{ name, ... }:
{
  deployment = {
    inherit tags;
    targetUser = if targetUser != null then targetUser else myvars.username;
    targetHost = if targetHost != null then targetHost else name;
  }
  // lib.optionalAttrs (targetPort != null) { inherit targetPort; }
  // lib.optionalAttrs (privilegeEscalationCommand != null) { inherit privilegeEscalationCommand; };

  imports =
    nixos-modules
    ++ (lib.optionals ((lib.lists.length home-modules) > 0) [
      home-manager.nixosModules.home-manager
      (
        { config, ... }:
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = spArgs;
          home-manager.users."${myvars.username}".imports = home-modules;
        }
      )
    ]);
}

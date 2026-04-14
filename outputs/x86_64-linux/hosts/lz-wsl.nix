# outputs/x86_64-linux/hosts/lz-wsl.nix
{
  # NOTE: the args not used in this file CAN NOT be removed!
  # because haumea pass argument lazily,
  # and these arguments are used in the functions like `mylib.nixosSystem`, `mylib.colmenaSystem`, etc.
  inputs,
  lib,
  mylib,
  myvars,
  system,
  genSpecialArgs,
  mysecrets,
  agenix,
  nixpkgs,
  home-manager,
  nixvim,
  ...
}@args:
let
  name = "lz-wsl";
  nodeConf = myvars.networking.hostsAddr.${name};

  modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        "hosts/${name}/default.nix"
        # modules"
        "secrets/nixos.nix"
      ])
      ++ [
        inputs.nixos-wsl.nixosModules.default
        {
          modules.secrets.desktop.enable = true;
          modules.secrets.mail.enable = false;
          # modules.desktop.gaming.enable = false;
          # modules.desktop.synopsys.enable = false;
          # modules.desktop.ai.enable = false;
        }
      ];
    home-modules = [
      (mylib.relativeToRoot "home/hosts/${name}.nix")
      inputs.nixvim.homeModules.nixvim
    ];
  };
  systemArgs = modules // args;
in
{
  nixosConfigurations.${name} = mylib.nixosSystem systemArgs;

  colmena.${name} = mylib.colmenaSystem (
    systemArgs
    // {
      targetHost = nodeConf.ipv4;
      targetUser = nodeConf.user;
      ssh-user = nodeConf.user;
      privilegeEscalationCommand = [
        "sudo"
        "-E"
      ];
      tags = [ "wsl" ];
    }
  );
}

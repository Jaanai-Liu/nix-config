# outputs/x86_64-linux/hosts/lz-aliyun-sh.nix
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
  hostname = "lz-aliyun-sh";
  nodeConf = myvars.networking.hostsAddr.${hostname};

  modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        "hosts/${hostname}/default.nix"
        # modules"
        "secrets/nixos.nix"
      ])
      ++ [
        inputs.disko.nixosModules.disko
        {
          modules.base.ssh.harden = true;
          # modules.secrets.server.proxy.enable = true;
          # modules.services.sing-box.enable = true;
        }
      ];
    home-modules = [
      (mylib.relativeToRoot "hosts/${hostname}/home.nix")
      inputs.nixvim.homeModules.nixvim
    ];
  };
  systemArgs = modules // args;
in
{
  nixosConfigurations.${hostname} = mylib.nixosSystem systemArgs;

  colmena.${hostname} = mylib.colmenaSystem (
    systemArgs
    // {
      targetHost = nodeConf.ipv4;
      targetUser = nodeConf.user;
      ssh-user = nodeConf.user;
      privilegeEscalationCommand = [
        "sudo"
        "-E"
      ];
      tags = [ "vps" ];
    }
  );
}

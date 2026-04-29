# outputs/x86_64-linux/hosts/lz-ali.nix
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
  name = "lz-ali";
  # nodeConf = myvars.networking.hostsAddr.${name};
  nodeConf = myvars.networking.hostsAddr.easytier.${name};
  # easytierConf = myvars.networking.hostsAddr.easytier.${name};

  modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        "hosts/${name}/default.nix"
        # modules"
        "secrets/nixos.nix"
      ])
      ++ [
        inputs.disko.nixosModules.disko
        {
          # server ssh
          modules.base.ssh.harden = true;

          # secrets
          modules.secrets.base.enable = true;
          # modules.secrets.server.proxy.enable = true;
          modules.secrets.server.siyuan.enable = true;
          modules.secrets.server.web-server.enable = true;

          # ===> EasyTier <===
          modules.base.easytier = {
            enable = true;
            ipv4 = nodeConf.ipv4;
          };

          # services
          # modules.services.sing-box.enable = true;
          modules.services.siyuan-server.enable = true;
          modules.services.obsidian-sync.enable = true;
          # web server
          modules.services.web-server.enable = true;

          # btrbk
          modules.btrbk.enable = true;
          modules.btrbk.role = "server";
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
      tags = [ "server" ];
    }
  );
}

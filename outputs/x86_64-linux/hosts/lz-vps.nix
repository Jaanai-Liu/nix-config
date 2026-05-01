# outputs/x86_64-linux/hosts/lz-vps.nix
{ args }:
let
  inherit (args) inputs lib mylib myvars system genSpecialArgs mysecrets agenix nixpkgs home-manager nixvim;
  name = "lz-vps";
  # nodeConf = myvars.networking.hostsAddr.${name};
  nodeConf = myvars.networking.hostsAddr.easytier.${name};

  modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        "hosts/${name}/default.nix"
        # modules"
        "secrets/nixos.nix"
      ])
      ++ [
        {
          # server ssh
          modules.base.ssh.harden = true;

          # secrets
          modules.secrets.base.enable = true;
          modules.secrets.server.proxy.enable = true;

          # sing-box
          modules.services.sing-box.enable = true;

          # btrbk
          modules.btrbk.enable = true;
          modules.btrbk.role = "server";

          # easytier
          modules.base.easytier = {
            enable = true;
            ipv4 = nodeConf.ipv4;
          };
        }
      ];
    home-modules = [
      (mylib.relativeToRoot "home/hosts/${name}.nix")
      # inputs.nixvim.homeModules.nixvim
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

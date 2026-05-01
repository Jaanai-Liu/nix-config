# outputs/x86_64-linux/hosts/lz-wsl.nix
{ args }:
let
  inherit (args) inputs lib mylib myvars system genSpecialArgs mysecrets agenix nixpkgs home-manager nixvim;
  name = "lz-wsl";
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
          # secrets
          modules.secrets.base.enable = true;
          modules.secrets.desktop.enable = true;
          modules.secrets.mail.enable = false;

          # desktop app
          # modules.desktop.gaming.enable = false;
          # modules.desktop.synopsys.enable = false;
          # modules.desktop.ai.enable = false;

          modules.base.easytier = {
            enable = true;
            ipv4 = nodeConf.ipv4;
          };
        }
      ];
    home-modules = [
      (mylib.relativeToRoot "home/hosts/${name}.nix")
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

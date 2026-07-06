# outputs/x86_64-linux/hosts/lz-nb.nix
{ args }:
let
  inherit (args) inputs mylib myvars pkgs-stable mysecrets agenix myfonts nixpkgs home-manager nixvim llm-agents;
  name = "lz-nb";

  easytierConf = myvars.networking.hostsAddr.easytier.${name};

  base-modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        "hosts/${name}/default.nix"
        "modules"
        "secrets/nixos.nix"
      ])
      ++ [
        {
          modules.secrets.base.enable = false;
          modules.secrets.desktop.enable = false;
          modules.secrets.mail.enable = false;
          modules.secrets.preservation.enable = false;

          modules.btrbk.enable = true;
          modules.btrbk.role = "workstation";

          modules.desktop.gaming.enable = true;
          modules.desktop.synopsys.enable = false;
          modules.desktop.ai.enable = false;

          modules.base.ssh.harden = false;
          modules.secrets.server.proxy.enable = false;

          modules.base.easytier = {
            enable = false;
            ipv4 = easytierConf.ipv4;
          };
        }
      ];

    home-modules =
      (map mylib.relativeToRoot [
        "home/hosts/${name}.nix"
      ])
      ;
  };

  modules-niri = {
    nixos-modules = [
      { programs.niri.enable = true; }
    ]
    ++ base-modules.nixos-modules;
    home-modules = base-modules.home-modules;
  };
in
{
  nixosConfigurations = {
    "${name}" = mylib.nixosSystem (
      modules-niri
      // args
      // {
        system = "x86_64-linux";
        lib = nixpkgs.lib;
        genSpecialArgs = (system: args);
      }
    );
  };
}

# outputs/x86_64-linux/hosts/lz-pc.nix
{
  inputs,
  mylib,
  myvars,
  pkgs-stable,
  mysecrets,
  agenix,
  myfonts,
  nixpkgs,
  home-manager,
  nixvim,
  ...
}@args:
let
  name = "lz-pc";

  easytierConf = myvars.networking.hostsAddr.easytier.${name};
  aliPublicIp = myvars.networking.hostsAddr.public.lz-ali.ipv4;

  base-modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        "hosts/${name}/default.nix"
        "modules"
        "secrets/nixos.nix"
      ])
      ++ [
        inputs.disko.nixosModules.disko
        # inputs.preservation.nixosModules.preservation
        {
          # secret
          modules.secrets.desktop.enable = true;
          modules.secrets.mail.enable = true;

          # btrbk
          modules.btrbk.enable = true;
          modules.btrbk.role = "workstation";

          # gui app config
          modules.desktop.gaming.enable = true;
          modules.desktop.synopsys.enable = false;
          modules.desktop.ai.enable = false;

          # server
          modules.base.ssh.harden = false;
          modules.secrets.server.proxy.enable = false;

          # easytier
          modules.base.easytier = {
            enable = true;
            ipv4 = easytierConf.ipv4;
            peers = [ "tcp://${aliPublicIp}:11010" ];
          };
        }
      ];

    home-modules =
      (map mylib.relativeToRoot [
        "home/hosts/${name}.nix"
      ])
      ++ [
        inputs.nixvim.homeModules.nixvim
      ];
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

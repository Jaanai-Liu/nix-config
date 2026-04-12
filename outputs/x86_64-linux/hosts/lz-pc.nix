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
  hostname = "lz-pc";
  base-modules = {
    nixos-modules =
      (map mylib.relativeToRoot [
        "hosts/${hostname}/default.nix"
        "modules"
        "secrets/nixos.nix"
      ])
      ++ [
        inputs.disko.nixosModules.disko
        inputs.preservation.nixosModules.preservation
        {
          # modules.secrets.desktop.enable = true;
          modules.desktop.gaming.enable = true;
          # modules.desktop.synopsys.enable = true;
          # modules.desktop.ai.enable = false;
        }
      ];

    home-modules =
      (map mylib.relativeToRoot [
        "hosts/${hostname}/home.nix"
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
    "${hostname}" = mylib.nixosSystem (
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

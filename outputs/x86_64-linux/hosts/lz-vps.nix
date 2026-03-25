# outputs/x86_64-linux/hosts/lz-vps.nix
{
  inputs,
  mylib,
  myvars,
  mysecrets,
  agenix,
  nixpkgs,
  home-manager,
  nixvim,
  ...
}:
let
  hostname = "lz-vps";
  nodeConf = myvars.networking.hostsAddr.${hostname};

  myModules = [
    inputs.disko.nixosModules.disko
    ../../../hosts/${hostname}/default.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          mylib
          myvars
          nixvim
          mysecrets
          agenix
          ;
      };
    }
  ];
in
{
  nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    specialArgs = {
      inherit
        inputs
        mylib
        myvars
        mysecrets
        agenix
        ;
    };
    modules = myModules; # 👈 引用清单
  };

  colmena.${hostname} = {
    imports = myModules; # 🌟 关键修复：把清单也给 Colmena 一份！

    deployment = {
      targetHost = nodeConf.ipv4;
      targetUser = nodeConf.user;
    };
  };
}

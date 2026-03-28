# outputs/x86_64-linux/hosts/lz-pc.nix
{
  inputs,
  mylib,
  myvars,
  pkgs-unstable,
  mysecrets,
  agenix,
  myfonts,
  nixpkgs,
  home-manager,
  nixvim,
  ...
}:
let
  hostname = "lz-pc";

  systemModules = [
    ../../../hosts/${hostname}/configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = {
        inherit
          inputs
          mylib
          myvars
          pkgs-unstable
          nixvim
          mysecrets
          agenix
          ;
      };
      home-manager.users.${myvars.username} = {
        imports = [
          ../../../hosts/${hostname}/home.nix
          inputs.nixvim.homeModules.nixvim
        ];
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
        pkgs-unstable
        mysecrets
        myfonts
        agenix
        ;
    };
    modules = systemModules;
  };

  colmena.${hostname} = {
    # 告诉 Colmena 怎么连接这台机器
    deployment = {
      targetHost = myvars.networking.hostsAddr.${hostname}.ipv4;
      targetUser = myvars.networking.hostsAddr.${hostname}.user;
      allowLocalDeployment = true;
    };

    imports = systemModules;
  };

  colmenaMeta = {
    nodeSpecialArgs.${hostname} = {
      inherit
        inputs
        mylib
        myvars
        pkgs-unstable
        mysecrets
        myfonts
        agenix
        ;
    };
  };
}

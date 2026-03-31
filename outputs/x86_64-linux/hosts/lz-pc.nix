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
}:
let
  hostname = "lz-pc";
  nodeConf = myvars.networking.hostsAddr.${hostname};
  mySpecialArgs = {
    inherit
      inputs
      mylib
      myvars
      pkgs-stable
      mysecrets
      myfonts
      agenix
      ;
  };
  myModules = [
    ../../../hosts/${hostname}/configuration.nix
    home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.extraSpecialArgs = mySpecialArgs // {
        inherit nixvim;
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
    specialArgs = mySpecialArgs;
    modules = myModules;
  };

  colmena.${hostname} = {
    imports = myModules;

    deployment = {
      targetHost = nodeConf.ipv4;
      targetUser = nodeConf.user;
      allowLocalDeployment = true;
    };
  };

  colmenaMeta = {
    nodeSpecialArgs.${hostname} = mySpecialArgs;
  };
}

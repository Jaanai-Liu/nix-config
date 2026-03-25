# outputs/x86_64-linux/lz-pc.nix
{
  inputs,
  mylib,
  myvars,
  mysecrets,
  agenix,
  myfonts,
  nixpkgs,
  home-manager,
  nixvim,
  ...
}:

nixpkgs.lib.nixosSystem {
  system = "x86_64-linux";
  specialArgs = {
    inherit
      inputs
      mylib
      myvars
      mysecrets
      myfonts
      agenix
      ;
  };

  modules = [
    ../../hosts/lz-pc/configuration.nix

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
      # 挂载 zheng 用户的独立环境
      home-manager.users.${myvars.username} = {
        imports = [
          ../../hosts/lz-pc/home.nix
          inputs.nixvim.homeModules.nixvim
        ];
      };
    }
  ];
}

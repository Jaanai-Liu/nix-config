# outputs/x86_64-linux/lz-vps.nix
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

nixpkgs.lib.nixosSystem {
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

  modules = [
    inputs.disko.nixosModules.disko
    ../../hosts/lz-vps/default.nix

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

      home-manager.users.root = {
        imports = [
          ../../home/base
          ../../home/tui
          inputs.nixvim.homeModules.nixvim
        ];
        home.stateVersion = "25.11";
      };
    }
  ];
}

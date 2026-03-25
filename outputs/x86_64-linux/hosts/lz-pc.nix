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
let
  hostname = "lz-pc";
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
        myfonts
        agenix
        ;
    };
    modules = [
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
  };
}

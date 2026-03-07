# outputs/x86_64-linux/default.nix
{ inputs, mylib, myvars, mysecrets, agenix, myfonts, nixpkgs, home-manager, ... }:

let
  system = "x86_64-linux";

  mkHost = hostName: nixpkgs.lib.nixosSystem {
    inherit system;
    specialArgs = { inherit inputs mylib myvars mysecrets myfonts agenix; };

    modules = [
      ../../hosts/${hostName}/configuration.nix
      
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs mylib myvars mysecrets agenix; };
        # 动态引入对应主机的home配置
        home-manager.users.${myvars.username} = import ../../hosts/${hostName}/home.nix;
      }
    ];
  };
in
{
  "lz-pc" = mkHost "lz-pc";
  "lz-laptop" = mkHost "lz-laptop";
  # 如果以后有第三台电脑，直接加一行 "新主机名" = mkHost "新主机名"; 即可
}

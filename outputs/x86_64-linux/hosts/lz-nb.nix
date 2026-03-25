# outputs/x86_64-linux/lz-laptop.nix
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
  hostname = "lz-laptop"; # 🌟 建议内部统一用 lz-laptop，或者跟你的目录名保持一致
in
{
  # 1. NixOS 基础定义
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
      ../../../hosts/${hostname}/configuration.nix # 🌟 注意：这里是三层 ../
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

  # 2. Colmena 部署定义
  colmena.${hostname} = {
    deployment = {
      # 如果你经常在笔记本上操作自己（Local Deploy），这里可以设为 null
      # 或者填入它的 Tailscale IP，方便从台式机远程控它
      targetHost = null;
      allowLocalDeployment = true;
    };
  };
}

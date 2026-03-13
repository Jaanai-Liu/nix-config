# outputs/default.nix
# inputs:
{ nixpkgs, home-manager, ... }@inputs:
let
  inherit (inputs) self nixpkgs home-manager;
  mylib = import ../lib { inherit (nixpkgs) lib; };
  myvars = import ../vars { inherit (nixpkgs) lib; };
  nixvim = inputs.nixvim;
  agenix = inputs.agenix;
  mysecrets = inputs.mysecrets;
  myfonts = inputs.myfonts;
  # 把所有工具打包成一个通用参数包
  args = { inherit inputs mylib myvars nixvim agenix mysecrets myfonts nixpkgs home-manager; };
in
{
  nixosConfigurations = import ./x86_64-linux args;
}

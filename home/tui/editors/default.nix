{ inputs, mylib, ... }:
{
  imports = mylib.scanPaths ./. ++ [
    inputs.nixvim.homeModules.nixvim
  ];
}

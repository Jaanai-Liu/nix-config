{ inputs, mylib, ... }:
{
  imports = mylib.scanPaths ./.;
}

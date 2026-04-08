{ mylib, ... }:
{
  # imports = mylib.scanPaths ./.;
  imports = [
    ./base
    ./desktop
  ];
}

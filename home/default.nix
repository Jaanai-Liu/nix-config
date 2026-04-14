{ mylib, ... }:
{
  # imports = mylib.scanPaths ./.;
  imports = [
    ./base
    ./tui
    ./gui
  ];
}

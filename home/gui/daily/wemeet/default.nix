{ pkgs, ... }:

let
  hooked-wemeet = pkgs.callPackage ./wemeet.nix { };
in
{
  home.packages = [
    hooked-wemeet
  ];
}

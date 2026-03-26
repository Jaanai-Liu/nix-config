# outputs/x86_64-linux/default.nix
# args: {
#   "lz-pc" = import ./lz-pc.nix args;
#   "lz-laptop" = import ./lz-laptop.nix args;
#   "lz-vps" = import ./lz-vps.nix args;
# }
{
  lib,
  inputs,
  ...
}@args:
let
  inherit (inputs) haumea;

  data = haumea.lib.load {
    src = ./hosts;
    inputs = args;
  };

  dataWithoutPaths = builtins.attrValues data;

  outputs = {
    nixosConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.nixosConfigurations or { }) dataWithoutPaths
    );

    colmena = lib.attrsets.mergeAttrsList (map (it: it.colmena or { }) dataWithoutPaths);

    colmenaMeta = {
      nodeNixpkgs = lib.attrsets.mergeAttrsList (
        map (it: it.colmenaMeta.nodeNixpkgs or { }) dataWithoutPaths
      );
      nodeSpecialArgs = lib.attrsets.mergeAttrsList (
        map (it: it.colmenaMeta.nodeSpecialArgs or { }) dataWithoutPaths
      );
    };
  };
in
outputs // { inherit data; }

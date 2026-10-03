{
  lib,
  inputs,
  ...
}@args:
let
  inherit (inputs) haumea;

  # Wrap args into a single attribute so haumea doesn't filter
  # individual inputs — new flake inputs flow through automatically.
  data = haumea.lib.load {
    src = ./hosts;
    inputs = { inherit args; };
  };

  dataWithoutPaths = builtins.attrValues data;

  outputs = {
    nixosConfigurations = lib.attrsets.mergeAttrsList (
      map (it: it.nixosConfigurations or { }) dataWithoutPaths
    );

    packages = lib.attrsets.mergeAttrsList (map (it: it.packages or { }) dataWithoutPaths);

    colmena = lib.attrsets.mergeAttrsList (map (it: it.colmena or { }) dataWithoutPaths);
  };
in
outputs // { inherit data; }

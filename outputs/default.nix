# outputs/default.nix
{ self, nixpkgs, ... }@inputs:
let
  inherit (nixpkgs) lib;

  mylib = import ../lib { inherit lib; };
  myvars = import ../vars { inherit lib; };

  # 安全检查：合并私有机密变量
  secret_vars_path = "${inputs.mysecrets}/vars";
  secret_vars =
    if (builtins.pathExists secret_vars_path) then import secret_vars_path { inherit lib; } else { };
  vars = lib.recursiveUpdate myvars secret_vars;

  genSpecialArgs =
    system:
    (builtins.removeAttrs inputs [ "self" ])
    // {
      inherit mylib;
      myvars = vars;
      inherit inputs;

      pkgs-unstable = import inputs.nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };
    };

  args = (builtins.removeAttrs inputs [ "self" ]) // {
    inherit
      inputs
      lib
      mylib
      genSpecialArgs
      ;
    myvars = vars;
    pkgs-unstable = import inputs.nixpkgs-unstable {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
  };

  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // { system = "x86_64-linux"; });
  };

  nixosSystemValues = builtins.attrValues nixosSystems;
in
{
  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or { }) nixosSystemValues
  );

  colmena = {
    meta =
      let
        system = "x86_64-linux";
      in
      {
        nixpkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
        specialArgs = genSpecialArgs system;
        nodeNixpkgs = lib.attrsets.mergeAttrsList (
          map (it: it.colmenaMeta.nodeNixpkgs or { }) nixosSystemValues
        );
        nodeSpecialArgs = lib.attrsets.mergeAttrsList (
          map (it: it.colmenaMeta.nodeSpecialArgs or { }) nixosSystemValues
        );
      };
  }
  // lib.attrsets.mergeAttrsList (map (it: it.colmena or { }) nixosSystemValues);

  formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
}

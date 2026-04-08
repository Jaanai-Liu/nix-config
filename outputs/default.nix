# outputs/default.nix
{
  self,
  nixpkgs,
  # pre-commit-hooks,
  ...
}@inputs:
let
  inherit (nixpkgs) lib;

  mylib = import ../lib { inherit lib; };
  myvars = import ../vars { inherit lib; };

  # secret_vars_path = "${inputs.mysecrets}/vars";
  # secret_vars =
  #   if (builtins.pathExists secret_vars_path) then import secret_vars_path { inherit lib; } else { };
  # vars = lib.recursiveUpdate myvars secret_vars;

  # Add my custom lib, vars, nixpkgs instance, and all the inputs to specialArgs,
  # so that I can use them in all my nixos/home-manager/darwin modules.
  genSpecialArgs =
    system:
    inputs
    # (builtins.removeAttrs inputs [ "self" ])
    // {
      inherit mylib myvars;
      # myvars = vars;
      # inherit inputs;

      pkgs-stable = import inputs.nixpkgs-stable {
        inherit system;
        config.allowUnfree = true;
      };
    };

  args = (builtins.removeAttrs inputs [ "self" ]) // {
    inherit
      inputs
      lib
      mylib
      myvars
      genSpecialArgs
      ;
  };

  nixosSystems = {
    x86_64-linux = import ./x86_64-linux (args // { system = "x86_64-linux"; });
    # aarch64-linux = import ./aarch64-linux (args // { system = "aarch64-linux"; });
  };
  darwinSystems = {
    # aarch64-darwin = import ./aarch64-darwin (args // { system = "aarch64-darwin"; });
  };
  allSystems = nixosSystems // darwinSystems;
  allSystemNames = builtins.attrNames allSystems;
  nixosSystemValues = builtins.attrValues nixosSystems;
  darwinSystemValues = builtins.attrValues darwinSystems;
  allSystemValues = nixosSystemValues ++ darwinSystemValues;

  # Helper function to generate a set of attributes for each system
  forAllSystems = func: (nixpkgs.lib.genAttrs allSystemNames func);

  # nixosSystemValues = builtins.attrValues nixosSystems;
in
{
  # Add attribute sets into outputs, for debugging
  debugAttrs = {
    inherit
      nixosSystems
      darwinSystems
      allSystems
      allSystemNames
      ;
  };

  # NixOS Hosts
  nixosConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.nixosConfigurations or { }) nixosSystemValues
  );

  # packages = forAllSystems (system: allSystems.${system}.packages or { });

  # Colmena - remote deployment via SSH
  colmena = {
    meta =
      let
        system = "x86_64-linux";
      in
      {
        nixpkgs = import nixpkgs { inherit system; };
        specialArgs = genSpecialArgs system;
      }
      // {
        nodeNixpkgs = lib.attrsets.mergeAttrsList (
          map (it: it.colmenaMeta.nodeNixpkgs or { }) nixosSystemValues
        );
        nodeSpecialArgs = lib.attrsets.mergeAttrsList (
          map (it: it.colmenaMeta.nodeSpecialArgs or { }) nixosSystemValues
        );
      };
  }
  // lib.attrsets.mergeAttrsList (map (it: it.colmena or { }) nixosSystemValues);

  darwinConfigurations = lib.attrsets.mergeAttrsList (
    map (it: it.darwinConfigurations or { }) darwinSystemValues
  );

  packages = forAllSystems (system: allSystems.${system}.packages or { });

  # Eval Tests for all NixOS & darwin systems.
  evalTests = lib.lists.all (it: it.evalTests == { }) allSystemValues;

  # checks = forAllSystems (system: {
  #   # eval-tests per system
  #   eval-tests = allSystems.${system}.evalTests == { };

  #   pre-commit-check = pre-commit-hooks.lib.${system}.run {
  #     src = mylib.relativeToRoot ".";
  #     hooks = {
  #       nixfmt-rfc-style = {
  #         enable = true;
  #         settings.width = 100;
  #       };
  #       # Source code spell checker
  #       typos = {
  #         enable = true;
  #         settings = {
  #           write = true; # Automatically fix typos
  #           configPath = ".typos.toml"; # relative to the flake root
  #           exclude = "rime-data/";
  #         };
  #       };
  #       prettier = {
  #         enable = true;
  #         settings = {
  #           write = true; # Automatically format files
  #           configPath = ".prettierrc.yaml"; # relative to the flake root
  #         };
  #       };
  #       # deadnix.enable = true; # detect unused variable bindings in `*.nix`
  #       # statix.enable = true; # lints and suggestions for Nix code(auto suggestions)
  #     };
  #   };
  # });

  # Development Shells
  devShells = forAllSystems (
    system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      default = pkgs.mkShell {
        packages = with pkgs; [
          # fix https://discourse.nixos.org/t/non-interactive-bash-errors-from-flake-nix-mkshell/33310
          bashInteractive
          # fix `cc` replaced by clang, which causes nvim-treesitter compilation error
          gcc
          # Nix-related
          nixfmt
          deadnix
          statix
          # spell checker
          typos
          # code formatter
          prettier
        ];
        name = "dots";
        inherit (self.checks.${system}.pre-commit-check) shellHook;
      };
    }
  );

  # Format the nix code in this flake
  formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
}

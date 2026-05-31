{ inputs, ... }:
{
  home.shellAliases = {
    v = "nvim";
    vi = "nvim";
    vim = "nvim";
  };

  home.sessionVariables.EDITOR = "nvim";

  home.packages = [
    inputs.nixvim.packages.x86_64-linux.default
  ];
}

{ lib, mylib, ... }:
{
  imports = mylib.scanPaths ./.;

  # options.modules.synopsys = {
  #   enable = lib.mkEnableOption "Synopsys EDA Tools User Environment";
  # };
}

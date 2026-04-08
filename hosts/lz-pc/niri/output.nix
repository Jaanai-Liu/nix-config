{ config, ... }:
let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  confPath = "${config.home.homeDirectory}/nix-config/hosts/lz-pc/niri";
in
{
  xdg.configFile."niri/output.kdl".source = mkSymlink "${confPath}/output.kdl";
}

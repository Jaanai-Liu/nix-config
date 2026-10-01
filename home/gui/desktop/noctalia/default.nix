{
  libs,
  pkgs,
  config,
  inputs,
  ...
}:
let
  noctalia-pkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
  # noctalia-pkg = pkgs.noctalia-shell;
in
{
  home.packages = [
    noctalia-pkg
    pkgs.qt6Packages.qt6ct
    # pkgs.app2unit
  ]
  ++ (pkgs.lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
    pkgs.gpu-screen-recorder
  ]);

  home.file."Pictures/wallpapers".source = inputs.wallpapers;

  xdg.configFile =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/home/gui/desktop/noctalia";
    in
    {
      # NOTE: use config dir as noctalia config because config is not only settings.json
      # https://github.com/noctalia-dev/noctalia-shell/blob/main/nix/home-module.nix#L211-L220
      "noctalia".source = mkSymlink "${confPath}/config";
      "qt6ct/qt6ct.conf".source = mkSymlink "${confPath}/qt6ct.conf";
    };
}

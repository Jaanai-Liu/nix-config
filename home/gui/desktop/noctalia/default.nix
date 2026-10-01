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
      # NOTE: noctalia v5 loads every *.toml in ~/.config/noctalia (this symlinked
      # dir), then ~/.local/state/noctalia/settings.toml (Settings UI changes)
      # overrides them. Declarative settings live in ./config/*.toml; UI changes
      # win at runtime, sync them back here to persist them in git.
      "noctalia".source = mkSymlink "${confPath}/config";
      "qt6ct/qt6ct.conf".source = mkSymlink "${confPath}/qt6ct.conf";
    };
}

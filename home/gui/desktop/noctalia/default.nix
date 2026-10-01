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

  xdg =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/home/gui/desktop/noctalia";
    in
    {
      # NOTE: noctalia v5's Settings UI persists to ~/.local/state/noctalia/settings.toml.
      # v5 explicitly supports a symlinked settings.toml: resolveAtomicWriteTarget()
      # resolves the link and writes atomically through it to the real file
      # (src/config/atomic_file.cpp), so GUI changes land in git directly.
      stateFile."noctalia/settings.toml".source = mkSymlink "${confPath}/settings.toml";
      configFile."qt6ct/qt6ct.conf".source = mkSymlink "${confPath}/qt6ct.conf";
    };
}

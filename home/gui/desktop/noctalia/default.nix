{
  libs,
  pkgs,
  config,
  inputs,
  ...
}:
let
  noctalia-pkg = inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = [
    noctalia-pkg
  ]
  ++ (pkgs.lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
    pkgs.gpu-screen-recorder
  ]);

  # Wallpapers: noctalia only references paths to ~/Pictures/wallpapers in its
  # settings.toml, the files themselves come from this flake input.
  home.file."Pictures/wallpapers".source = inputs.wallpapers;

  xdg.stateFile =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/home/gui/desktop/noctalia";
    in
    {
      # NOTE: noctalia v5's Settings UI persists the whole user config (bar,
      # theme, wallpaper paths, lockscreen widgets) to this one file; v5 writes
      # atomically through the symlink to the real file, so GUI changes land
      # in git directly.
      "noctalia/settings.toml".source = mkSymlink "${confPath}/settings.toml";
    };
}

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
      # NOTE: noctalia v5 keeps all user state in ~/.local/state/noctalia.
      # Symlink the whole dir into the repo; state/.gitignore whitelists only
      # settings.toml (the declarative config) and keeps runtime data
      # (notification/launcher history, template & plugin caches) out of git.
      # v5 writes files atomically inside the dir, so Settings UI changes land
      # in git directly.
      "noctalia".source = mkSymlink "${confPath}/state";
    };
}

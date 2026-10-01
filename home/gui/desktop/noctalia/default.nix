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
  ]
  ++ (pkgs.lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
    pkgs.gpu-screen-recorder
  ]);

  # Use the upstream Home Manager module (shipped by home-manager itself) for
  # the package. The config file is not deployed through `programs.noctalia.settings`:
  # that writes a store symlink, so every edit needs a home-manager switch.
  # https://docs.noctalia.dev/noctalia/getting-started/nixos/#home-manager
  # programs.noctalia.enable = true;

  # Noctalia v5 is started by niri's spawn-at-startup (see the niri conf), so
  # app2unit is still used to launch desktop entries as systemd user units.
  # home.packages = [
  #   pkgs.app2unit # Launch Desktop Entries (or arbitrary commands) as Systemd user units
  # ]
  # ++ (lib.optionals pkgs.stdenv.hostPlatform.isx86_64 [
  #   pkgs.gpu-screen-recorder # recoding screen
  # ]);

  # Wallpapers: noctalia only references paths to ~/Pictures/wallpapers in its
  # settings.toml, the files themselves come from this flake input.
  home.file."Pictures/wallpapers".source = inputs.wallpapers;

  xdg.stateFile."noctalia" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/gui/desktop/noctalia/conf";
  };
}

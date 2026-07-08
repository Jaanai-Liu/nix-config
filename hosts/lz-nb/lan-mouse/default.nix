{
  config,
  ...
}:
{
  imports = [ ../../../home/gui/lan-mouse ];

  xdg.configFile."lan-mouse/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/hosts/lz-nb/lan-mouse/config.toml";
}

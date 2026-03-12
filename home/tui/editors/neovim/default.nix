{ config, pkgs, lib, ... }:

let
  shellAliases = {
    v = "nvim";
    vdiff = "nvim -d";
  };
  configPath = "${config.home.homeDirectory}/nix-config/home/tui/editors/neovim/nvim";
in
{
  xdg.configFile."nvim".source = config.lib.file.mkOutOfStoreSymlink configPath;

  home.shellAliases = shellAliases;
  programs.nushell.shellAliases = shellAliases;
  programs.neovim = {
    enable = true;
    package = pkgs.neovim-unwrapped;

    viAlias = true;
    vimAlias = true;

    extraWrapperArgs = with pkgs; [
      "--suffix" "LIBRARY_PATH" ":" "${lib.makeLibraryPath [ stdenv.cc.cc zlib ]}"
      "--suffix" "PKG_CONFIG_PATH" ":" "${lib.makeSearchPathOutput "dev" "lib/pkgconfig" [ stdenv.cc.cc zlib ]}"
    ];

    extraPackages = [];
  };
}

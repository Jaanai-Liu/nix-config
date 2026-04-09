# home/tui/dev-tools/direnv.nix
{ pkgs, ... }:

{
  home.packages = [ pkgs.devenv ];
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    enableZshIntegration = true;
    enableBashIntegration = true;

    stdlib = ''
      use_devenv() {
        watch_file devenv.nix
        watch_file devenv.yaml
        eval "$(devenv print-dev-env)"
      }
    '';

    config = {
      global = {
        hide_env_diff = true;
      };
    };
  };
  programs.zsh.shellAliases = {
    dev-start = "devenv init && echo 'use devenv' > .envrc && direnv allow";
  };
}

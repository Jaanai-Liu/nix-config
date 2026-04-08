{
  pkgs,
  config,
  inputs,
  ...
}:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fastfetch
    neovim

    wget
    git
    curl
    git

    # system monitoring
    htop

    # system tools
    psmisc # killall/pstree/prtstat/fuser/...

  ];
  environment.variables.EDITOR = "neovim";
}

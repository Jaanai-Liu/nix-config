{
  pkgs,
  config,
  ...
}:
{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    fastfetch
    vim-full
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    tmux # Terminal split tool
    wget
    git

    # system monitoring
    btop
    # htop
    
    tree
    

    # system tools
    psmisc # killall/pstree/prtstat/fuser/...
    lm_sensors # for `sensors` command
    pciutils # lspci
    usbutils # lsusb
    parted

    fuse

    strace #调试检查缺了什么strace snipaste 2>&1 | grep -iE "error|no such file"
    
  ];


  # BCC - Tools for BPF-based Linux IO analysis, networking, monitoring, and more
  # https://github.com/iovisor/bcc
  # programs.bcc.enable = true;

  # replace default editor with neovim
  environment.variables.EDITOR = "vim-full";
}

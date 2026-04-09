{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # gcc
    # gnumake

    ripgrep
    fzf
    gdu
    wl-clipboard
    stylua
    fd
    tree-sitter

    nil
    nixd
    nixfmt

    # Markdown
    marksman
    glow

    verible # verilog
  ];
}

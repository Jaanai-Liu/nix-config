{ pkgs, ... }:
{
  home.packages = with pkgs; [
    gcc
    gnumake
    ripgrep
    fzf
    gdu
    wl-clipboard
    stylua
    fd
    tree-sitter

    nil
    nixd
    nixfmt-rfc-style

    # Markdown
    marksman
    glow

    cargo
    rustc
    rust-analyzer
    rustfmt
    clippy

    verible # verilog
  ];
}

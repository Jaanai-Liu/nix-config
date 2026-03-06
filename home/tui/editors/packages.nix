{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # 1.AstroNvim基础核心依赖(必须安装，否则插件报错)
    gcc             # 编译Treesitter语法树
    gnumake         # 编译部分底层C插件
    ripgrep         # 核心搜索工具(Telescope依赖)
    fzf             # 模糊查找核心
    gdu             # 磁盘占用分析(AstroNvim界面依赖)
    wl-clipboard    # Wayland剪贴板支持(实现Neovim与系统复制粘贴互通)
    stylua          # Lua代码格式化(AstroNvim配置文件需要)

    # 2.Nix系统级配置开发支持
    nil
    nixd
    nixfmt-rfc-style

    # Markdown
    marksman
    glow
  ];
}
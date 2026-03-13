# modules/vim.nix
{ config, pkgs, ... }:
{
  home.packages = with pkgs;[
    nodejs
    font-awesome
    font-awesome_6

    nixd nixfmt-rfc-style # Nix
    # rustc cargo rust-analyzer # Rust
    # go gopls # Go
    # jdk17 # Java (可以根据需求换成 jdk21)
  ];
  programs.vim = {
    enable = true;
    defaultEditor = true;
    plugins = with pkgs.vimPlugins; [
      nerdtree                 # Preservim/nerdtree
      gruvbox                  # morhetz/gruvbox
      vim-airline              # vim-airline
      vim-airline-themes
      coc-nvim                 # neoclide/coc.nvim 
      verilog_systemverilog-vim
      vim-nix
      rust-vim
      vim-go
    ];

    # 将 vimrc 中的设置直接贴在这里
    extraConfig = ''
      set clipboard=unnamedplus
      set nocompatible
      filetype plugin indent on
      syntax on
      set encoding=utf-8
      set number
      set cursorline
      set ruler
      set nowrap

      set guioptions-=m " 隐藏菜单栏
      set guioptions-=T " 隐藏工具栏
      set guioptions-=r " 隐藏右侧滚动条
      set guioptions-=L " 隐藏左侧滚动条

      set cursorline   " 高亮行
      set cursorcolumn " 高亮列
      highlight CursorLine   guibg=#3e4452 ctermbg=236
      highlight CursorColumn guibg=#3e4452 ctermbg=236
      nnoremap <F3> :set cursorline! cursorcolumn!<CR>
      
      " 字体设置 (从你的 vimrc 复制)
      if has("gui_running")
        set guifont=DejaVu\ Sans\ Mono\ 13
        set guifontwide=Noto\ Sans\ CJK\ SC\ 13
      endif

      " 缩进
      set tabstop=4
      set softtabstop=4
      set shiftwidth=4
      set expandtab
      set autoindent

      autocmd FileType nix,rust setlocal tabstop=2 shiftwidth=2 softtabstop=2


      " 配色
      try
          colorscheme gruvbox
          set background=dark
      catch
          colorscheme desert
      endtry

      " NERDTree 快捷键 [cite: 33]
      nnoremap <F4> :NERDTreeToggle<CR>
      " autocmd VimEnter * NERDTree | if argc() > 0 | wincmd p | endif
      autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

      " COC 补全设置 [cite: 35]
      inoremap <silent><expr> <TAB>
            \ coc#pum#visible() ? coc#pum#next(1) :
            \ CheckBackspace() ? "\<Tab>" :
            \ coc#refresh()
      inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
      inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                             \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

      function! CheckBackspace() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~# '\s'
      endfunction
    '';
  };
}

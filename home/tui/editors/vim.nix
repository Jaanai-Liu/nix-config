# modules/vim.nix
{ config, pkgs, ... }:
{
  home.packages = with pkgs;[
    nodejs
    font-awesome
    font-awesome_6
  ];
  programs.vim = {
    enable = true;
    # package = pkgs.vim-full; 
    defaultEditor = true; # 会自动设置 EDITOR=vim
    # 使用 Nix 管理插件，替代 vim-plug 
    plugins = with pkgs.vimPlugins; [
      nerdtree                 # Preservim/nerdtree
      gruvbox                  # morhetz/gruvbox
      vim-airline              # vim-airline
      vim-airline-themes
      coc-nvim                 # neoclide/coc.nvim 
      verilog_systemverilog-vim # vhda/verilog_systemverilog.vim (需要确认pkgs里具体名字，通常是这个)
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
      
      " 字体设置 (从你的 vimrc 复制)
      if has("gui_running")
        set guifont=DejaVu\ Sans\ Mono\ 11
        set guifontwide=Noto\ Sans\ CJK\ SC\ 11
      endif

      " 缩进
      set tabstop=4
      set softtabstop=4
      set shiftwidth=4
      set expandtab
      set autoindent

      " 配色
      try
          colorscheme gruvbox
          set background=dark
      catch
          colorscheme desert
      endtry

      " NERDTree 快捷键 [cite: 33]
      nnoremap <F2> :NERDTreeToggle<CR>
      autocmd VimEnter * NERDTree | if argc() > 0 | wincmd p | endif
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

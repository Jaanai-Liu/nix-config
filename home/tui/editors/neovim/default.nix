{ inputs, pkgs, ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    # viAlias = true;
    vimAlias = true;

    # Color scheme configuration
    colorschemes.gruvbox = {
      enable = true;
      settings = {
        transparent_mode = true;
        contrast = "hard"; 
      };
    };

    # Global editor options
    opts = {
      number = true;              # Show line numbers
      relativenumber = true;      # Relative line numbers for easier jumping
      
      # Unified Indentation (2 spaces for all languages)
      shiftwidth = 2;             
      tabstop = 2;                
      expandtab = true;           # Convert tabs to spaces
      smartindent = true;         
      
      # UI elements
      cursorline = true;          # Highlight the current line
      cursorcolumn = true;        # Highlight the current column (crosshair)
      termguicolors = true;       # True color support
      clipboard = "unnamedplus";  # Sync with system clipboard
      mouse = "a";                # Enable mouse support
      scrolloff = 8;              # Keep 8 lines above/below cursor when scrolling
    };

    plugins = {
      web-devicons.enable = true; # Required for file icons

      # Syntax highlighting
      treesitter = {
        enable = true;
        settings = {
          ensure_installed = [ 
            "nix" "rust" "python" "verilog" "lua" "bash" "markdown" "cpp"
          ];
          highlight.enable = true;
        };
      };

      # Language Server Protocol (LSP)
      lsp = {
        enable = true;
        servers = {
          verible.enable = true;    # Verilog/SystemVerilog
          rust_analyzer = {         # Rust
            enable = true;
            installCargo = true;
            installRustc = true;
          };
          nixd.enable = true;       # Nix
          pyright.enable = true;    # Python
          bashls.enable = true;     # Bash
          lua_ls.enable = true;     # Lua
        };
      };

      # Autocompletion
      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };
        };
      };

      # File explorer and UI
      neo-tree.enable = true;       # File tree sidebar
      lualine.enable = true;        # Bottom status bar
      bufferline.enable = true;     # Top buffer/tab bar
      
      # Floating Terminal integration
      toggleterm = {
        enable = true;
        settings = {
          direction = "float";
          open_mapping = "[[<C-t>]]"; # Ctrl+t to toggle floating terminal
          shell = "zsh";
          float_opts.border = "curved";
        };
      };
    };

    # Custom Keybindings
    keymaps = [
      # Sidebar toggle
      { mode = "n"; key = "<F4>"; action = ":Neotree toggle<CR>"; options.desc = "Toggle Sidebar"; }
      
      # Buffer navigation (Switch between open files)
      { mode = "n"; key = "L"; action = ":bnext<CR>"; options.desc = "Next Buffer"; }
      { mode = "n"; key = "H"; action = ":bprevious<CR>"; options.desc = "Previous Buffer"; }
      
      # Split window navigation
      { mode = "n"; key = "<C-h>"; action = "<C-w>h"; }
      { mode = "n"; key = "<C-l>"; action = "<C-w>l"; }
      { mode = "n"; key = "<C-j>"; action = "<C-w>j"; }
      { mode = "n"; key = "<C-k>"; action = "<C-w>k"; }
    ];

    extraConfigLua = ''
      -- Exit terminal mode with double Esc
      function _G.set_terminal_keymaps()
        local opts = {buffer = 0}
        vim.keymap.set('t', '<esc><esc>', [[<C-\><C-n>]], opts)
      end
      vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    '';
  };
}

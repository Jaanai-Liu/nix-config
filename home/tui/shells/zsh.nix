# modules/zsh.nix
{ config, pkgs, ... }:
{
  # Zsh 配置 (替代 .zshrc)
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;      # 对应 zsh-autosuggestions
    syntaxHighlighting.enable = true;  # 对应 zsh-syntax-highlighting

    # 对应 Oh My Zsh 配置 [cite: 3]
    oh-my-zsh = {
      enable = true;
      # theme = "robbyrussell";          # 对应 ZSH_THEME [cite: 3]
      plugins = [ "git" "z" ]; # 对应 plugins=(...) 
    };

    # 对应 alias 配置 [cite: 21]
    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      f = "fastfetch";
      g = "gvim";
      c = "code";
      b = "cd ..";
      py = "python3";
      # 注意：conda activate 最好在 initExtra 中处理，或直接在 shell 中使用
      mlp = "conda activate mlp";
      nixclear = "sudo nix-collect-garbage -d";
      # fixchrome = "pkill -f chrome; rm -rf ~/.config/google-chrome/Singleton*";
    };

    # 这里放入所有原本 zshrc 中无法标准化的脚本 (Conda, 函数, export 等)
    initContent = ''
      # PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%~%{$reset_color%} \$(git_prompt_info)"
      
      # 强制设置环境变量
      export IM_MODULE=fcitx
      export GTK_IM_MODULE=fcitx
      export QT_IM_MODULE=fcitx
      export XMODIFIERS="@im=fcitx"

      function ma() {
        if [ -z "$1" ]; then
          echo "用法：ma <包名1> [包名2] ..."
          return 1
        fi # <- 增加了闭合的 fi

        local cmd="nix shell" # 统一变量名并初始化
        for arg in "$@"; do   # <- 改为了小写的 do
          cmd="$cmd nixpkgs#$arg"
        done
        
        echo "正在进入Nix环境：$cmd"
        eval "$cmd"
      }

      function mav() {
        if [ -z "$1" ]; then
          echo "用法: mav <搜索关键词>"
          return 1
        fi

        echo "🔍 正在Nixpkgs库中搜索'$1'..."
        echo "提示：第一次搜索可能需要下载缓存索引，请耐心等待..."
        echo "---------------------------------------------------"

        # nix search的输出传递给grep，再传递给sed
        nix search nixpkgs "$1" 2>/dev/null |
        grep "^* " |
        sed -E 's/^\* (legacyPackages\.[^.]+\.|nixpkgs#)//'
    
        echo "---------------------------------------------------"
        echo "👉 使用'ma <名字>'即可使用对应版本"
      }
      
      # 自定义函数
      function cd() {
          builtin cd "$@" && ls
      }
      
      # Micromamba 初始化
      export MAMBA_ROOT_PREFIX=$HOME/micromamba
      export MAMBA_CHANGE_PS1=false
      eval "$(micromamba shell hook --shell zsh)"
      alias conda="micromamba"

      # auto-act & change color
      micromamba activate base
    '';
  };
}

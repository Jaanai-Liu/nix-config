{ config, pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      # theme = "robbyrussell";
      plugins = [
        "git"
        "z"
      ];
    };

    shellAliases = {
      ll = "ls -alF";
      la = "ls -A";
      l = "ls -CF";
      f = "fastfetch";
      # g = "gvim";
      v = "nvim";
      c = "code";
      b = "cd ..";
      py = "python3";
      nixclear = "sudo nix-collect-garbage -d";
    };

    initContent = ''
      # PROMPT="%(?:%{$fg_bold[green]%}➜ :%{$fg_bold[red]%}➜ ) %{$fg[cyan]%}%~%{$reset_color%} \$(git_prompt_info)"
      export TERM=xterm-256color

      # Force set environment variables for input method
      export IM_MODULE=fcitx
      export GTK_IM_MODULE=fcitx
      export QT_IM_MODULE=fcitx
      export XMODIFIERS="@im=fcitx"

      function ma() {
        if [ -z "$1" ]; then
          echo "Usage: ma <package1> [package2] ..."
          return 1
        fi # Added closing fi

        local cmd="nix shell"
        for arg in "$@"; do
          cmd="$cmd nixpkgs#$arg"
        done
        
        echo "Entering Nix environment: $cmd"
        eval "$cmd"
      }

      function mav() {
        if [ -z "$1" ]; then
          echo "Usage: mav <search_keyword>"
          return 1
        fi

        echo "🔍 Searching for '$1' in Nixpkgs..."
        echo "Tip: The first search may require downloading the cache index, please be patient..."
        echo "---------------------------------------------------"

        # Pipe nix search output to grep, then to sed
        # nix search nixpkgs "$1" 2>/dev/null |
        # grep "^* " |
        # sed -E 's/^\* (legacyPackages\.[^.]+\.|nixpkgs#)//'
        NO_COLOR=1 nix search nixpkgs "$1" 2>/dev/null | awk '/^\* / {
          sub(/^legacyPackages\.[^.]*\./, "", $2)
          sub(/^nixpkgs#/, "", $2)
          $1 = ""
          print substr($0, 2)
        }'

        echo "---------------------------------------------------"
        echo "👉 Use 'ma <name>' to enter the corresponding environment"
      }

      function cd() {
          builtin cd "$@" && ls
      }
    '';
  };
}

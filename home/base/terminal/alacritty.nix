{ lib, pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    source-code-pro
    papirus-icon-theme
    maple-mono.NF-CN
  ];

  programs.alacritty = {
    enable = true;

    settings = {
      window = {
        opacity = 0.85;
        # startup_mode = "Maximized";
        dynamic_title = true;
        option_as_alt = "Both";
        decorations = "None";
      };

      scrolling = {
        history = 10000;
      };

      font = {
        normal = {
          # family = "JetBrainsMono Nerd Font";
          family = "Maple Mono NF CN";
        };
        bold = {
          # family = "JetBrainsMono Nerd Font";
          family = "Maple Mono NF CN";
        };
        italic = {
          # family = "JetBrainsMono Nerd Font";
          family = "Maple Mono NF CN";
        };
        bold_italic = {
          # family = "JetBrainsMono Nerd Font";
          family = "Maple Mono NF CN";
        };
        size = 13.0;
      };

      terminal = {
        shell = {
          program = "${pkgs.bash}/bin/bash";
          args = [
            "--login"
            "-c"
            "${pkgs.zsh}/bin/zsh --login --interactive"
          ];
        };
        osc52 = "CopyPaste";
      };
    };
  };

  xdg.desktopEntries.alacritty = {
    name = "Alacritty";
    genericName = "Terminal emulator";
    exec = "alacritty";
    icon = "${pkgs.papirus-icon-theme}/share/icons/Papirus/48x48/apps/utilities-terminal.svg";
    terminal = false;
    categories = [
      "System"
      "TerminalEmulator"
    ];
  };
}

{
  config,
  pkgs,
  lib,
  ...
}:
let
  # ==============================================================
  # 🎨 Theme Toggle Switch
  # Set your desired configuration name here:
  #   - "shorin" : Your color-block/Powerline style config (fixed font icons)
  #   - "ryan"   : The original author's minimalist plain-text config
  # ==============================================================
  activeTheme = "ryan";

  # ==============================================================
  # Config 1: shorin (Color-block style)
  # ==============================================================
  shorinSettings = {
    format = lib.concatStrings [
      "[](color_first)"
      "$os"
      "$username"
      "[](bg:color_yellow fg:color_first)"
      "$directory"
      "[](fg:color_yellow bg:color_aqua)"
      "$git_branch"
      "$git_status"
      "[](fg:color_aqua bg:color_purple)"
      "$c$rust$python$nix_shell"
      "[](fg:color_purple bg:color_bg3)"
      "$time"
      "[ ](fg:color_bg1)"
      "$line_break"
      "$character"
    ];

    palette = "catppuccin_mocha";
    palettes.catppuccin_mocha = {
      color_first = "#cba6f7";
      color_yellow = "#f9e2af";
      color_aqua = "#94e2d5";
      color_purple = "#cba6f7";
      color_bg3 = "#585b70";
      color_bg1 = "#313244";
      color_fg0 = "#11111b";
      color_fg1 = "#cdd6f4";
      color_green = "#a6e3a1";
      color_red = "#f38ba8";
    };

    os = {
      disabled = false;
      style = "bg:color_first fg:color_fg0";
      symbols.NixOS = "❄️ ";
    };

    username = {
      show_always = true;
      style_user = "bg:color_first fg:color_fg0";
      format = "[ $user ]($style)";
    };

    directory = {
      style = "fg:color_fg0 bg:color_yellow";
      format = "[ $path ]($style)";
      truncation_length = 3;
    };

    git_branch = {
      symbol = ""; # Replaced with universal branch icon
      style = "bg:color_aqua";
      format = "[[ $symbol $branch ](fg:color_fg0 bg:color_aqua)]($style)";
    };

    git_status = {
      style = "bg:color_aqua";
      format = "[[ $all_status$ahead_behind ](fg:color_fg0 bg:color_aqua)]($style)";
    };

    python = {
      symbol = "🐍";
      style = "bg:color_purple";
      format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_purple)]($style)";
    };
    c = {
      symbol = " ";
      style = "bg:color_purple";
      format = "[[ $symbol( $version) ](fg:color_fg0 bg:color_purple)]($style)";
    };
    nix_shell = {
      symbol = "❄️ ";
      style = "bg:color_purple";
      format = "[[ $symbol ](fg:color_fg0 bg:color_purple)]($style)";
    };

    time = {
      disabled = false;
      style = "bg:color_bg1";
      format = "[[ 󰥔 $time ](fg:color_fg1 bg:color_bg1)]($style)";
    };

    character = {
      success_symbol = "[➜](bold fg:color_green)";
      error_symbol = "[➜](bold fg:color_red)";
    };
  };

  # ==============================================================
  # Config 2: ryan (Minimalist style)
  # ==============================================================
  ryanSettings = {
    add_newline = false;

    # hostname
    hostname = {
      ssh_only = false;
      format = "[$hostname]($style) ";
      style = "bold purple";
    };

    # config path
    directory = {
      style = "bold cyan";
      format = "[$path]($style)[$read_only]($read_only_style) ";
      truncation_length = 0; # display N flod
      truncate_to_repo = false; # git repo, do not hide path
    };

    "$schema" = "https://starship.rs/config-schema.json";
    character = {
      success_symbol = "[➜](bold green)";
      error_symbol = "[➜](bold red)";
    };
    aws.disabled = true;
    gcloud.disabled = true;

    kubernetes = {
      symbol = "⛵";
      disabled = false;
    };
    os.disabled = false;
  };

in
{
  programs.starship = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    enableNushellIntegration = true;

    # Load the selected settings based on the activeTheme variable defined above
    settings = if activeTheme == "shorin" then shorinSettings else ryanSettings;
  };
}

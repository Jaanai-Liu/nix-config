{ pkgs, ... }:

{
  # 保证字体被安装，高内聚写法
  home.packages = with pkgs; [
    maple-mono.NF-CN
  ];

  programs.foot = {
    # foot is designed only for Linux
    enable = pkgs.stdenv.isLinux;
    # enable = true;

    # foot can also be run in a server mode. In this mode, one process hosts multiple windows.
    # All Wayland communication, VT parsing and rendering is done in the server process.
    # New windows are opened by running footclient, which remains running until the terminal window is closed.
    #
    # Advantages to run foot in server mode including reduced memory footprint and startup time.
    # The downside is a performance penalty. If one window is very busy with, for example, producing output,
    # then other windows will suffer. Also, should the server process crash, all windows will be gone.
    server.enable = true;

    # https://man.archlinux.org/man/foot.ini.5
    settings = {
      main = {
        term = "foot"; # or "xterm-256color" for maximum compatibility
        font = "Maple Mono NF CN:size=13";
        dpi-aware = "no"; # scale via window manager instead
        resize-keep-grid = "no"; # do not resize the window on font resizing

        # Spawn a nushell in login mode via `zsh`
        shell = "${pkgs.zsh}/bin/zsh --login";
        # shell = "${pkgs.bash}/bin/bash --login -c 'nu --login --interactive'";

        # pad = "12x12 center";
      };

      mouse = {
        hide-when-typing = "yes";
      };

      csd = {
        preferred = "none";
      };

      colors-dark = {
        alpha = "0.85";

        foreground = "cdd6f4";
        # background = "1e1e2e";
        # background = "111111";
        background = "000000";

        regular0 = "45475a"; # black
        regular1 = "f38ba8"; # red
        regular2 = "a6e3a1"; # green
        regular3 = "f9e2af"; # yellow
        regular4 = "89b4fa"; # blue
        regular5 = "f5c2e7"; # magenta
        regular6 = "94e2d5"; # cyan
        regular7 = "bac2de"; # white

        bright0 = "585b70"; # bright black
        bright1 = "f38ba8"; # bright red
        bright2 = "a6e3a1"; # bright green
        bright3 = "f9e2af"; # bright yellow
        bright4 = "89b4fa"; # bright blue
        bright5 = "f5c2e7"; # bright magenta
        bright6 = "94e2d5"; # bright cyan
        bright7 = "a6adc8"; # bright white
      };
    };
  };
}

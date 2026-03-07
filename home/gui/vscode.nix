{
  lib,
  pkgs,
  ...
}:

let
  vscodeCliArgs = [
    # https://code.visualstudio.com/docs/configure/settings-sync#_recommended-configure-the-keyring-to-use-with-vs-code
    # For use with any package that implements the Secret Service API
    # (for example gnome-keyring, kwallet5, KeepassXC)
    # "--password-store=gnome-libsecret"
  ];
in
{
  home.packages = [
    # pkgs-master.code-cursor
    # pkgs-master.zed-editor
    # pkgs-master.antigravity-fhs
  ];

  programs.vscode = {
    enable = true;
    package = pkgs.vscode; 
    # package = pkgs.vscode.override {
    #   commandLineArgs = vscodeCliArgs;
    # };
    # profiles.default = {
    #   userSettings = {
    #     # --- 字体美化部分 ---
    #     # 假设你的 Kitty 使用的是 JetBrainsMono Nerd Font (Linux 极客标配)
    #     "editor.fontFamily" = "'JetBrainsMono Nerd Font', 'monospace', 'Droid Sans Mono'";
    #     "editor.fontLigatures" = true;      # 开启连字（让 != 变成一个精美的符号）
    #     "editor.fontSize" = 14;             # 稍微调大一点，看着不累
    #     "editor.fontWeight" = "400";
    #     
    #     # 内置终端也同步 Kitty 字体，保持一致性
    #     "terminal.integrated.fontFamily" = "JetBrainsMono Nerd Font";
    #     
    #     # --- 其他常规优化 ---
    #     "workbench.colorTheme" = "Catppuccin Macchiato"; # 推荐一套跟 Noctalia 很搭的主题
    #     "editor.cursorBlinking" = "smooth";
    #     "editor.smoothScrolling" = true;
    #   };
    # };
  };
}
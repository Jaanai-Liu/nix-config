{ pkgs, ... }:

let
  remoteConf = builtins.toFile "tmux.remote.conf" ''
    unbind C-b
    unbind b
    set-option -g prefix C-s
    bind s send-prefix
    bind C-s last-window
    set-option -g status-position top
  '';
in
{
  programs.tmux = {
    enable = true;
    shortcut = "b";
    escapeTime = 10;
    keyMode = "vi";
    terminal = "tmux-256color";
    historyLimit = 50000;

    mouse = true;
    baseIndex = 1;
    focusEvents = true;

    plugins = with pkgs.tmuxPlugins; [
      copycat
      sensible
      urlview
      {
        plugin = prefix-highlight;
        extraConfig = ''
          set-option -g @prefix_highlight_fg '#282828' # 文字：深炭灰色
          set-option -g @prefix_highlight_bg '#b8bb26' # 背景：明亮黄绿色
        '';
      }
    ];

    extraConfig = ''
      # === 快捷键配置 ===
      # 热重载配置文件 (Prefix + 大写 R)
      bind-key R run-shell ' \
        tmux source-file /etc/tmux.conf > /dev/null; \
        tmux display-message "sourced /etc/tmux.conf"'

      # 如果是通过 SSH 连进来的，加载 remoteConf
      if -F "$SSH_CONNECTION" "source-file '${remoteConf}'"

      # 粘贴时使用 bracketed paste mode (防止缩进错乱)
      bind ] paste-buffer -p

      # === 🖱️ 剪贴板终极解决方案 (Wayland) ===
      # 1. 开启 OSC 52 支持 (现代终端原生剪贴板交互)
      set-option -s set-clipboard on

      # 2. 绑定鼠标左键拖拽结束，强制通过管道打入 Wayland 剪贴板
      bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"

      # 3. 绑定回车键复制，强制通过管道打入 Wayland 剪贴板
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"

      # 4. 保留 Prefix + Ctrl-y 作为手动备用手段
      bind C-y run-shell ' \
        ${pkgs.tmux}/bin/tmux show-buffer > /dev/null 2>&1 \
        && ${pkgs.tmux}/bin/tmux show-buffer | ${pkgs.wl-clipboard}/bin/wl-copy'

      # === 行为与窗口配置 ===
      # 分屏时保持当前所在目录
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      set-option -g set-titles on
      set-option -ga terminal-overrides ",*:Tc" # 开启真色彩
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on

      # === 🎨 颜色配置 (Gruvbox 主题) ===
      set-option -g status-right ' #{prefix_highlight} "#{=21:pane_title}" %H:%M %d-%b-%y'
      set-option -g status-left-length 20

      # 状态栏全局颜色
      set-option -g status-style 'fg=#928374, bg=#282828'
      # 当前激活窗口的名字颜色
      set-option -g window-status-current-style 'fg=#b8bb26'
      # 窗格分界线颜色
      set-option -g pane-border-style 'fg=#282828'
      set-option -g pane-active-border-style 'fg=#b8bb26'
      # 消息提示栏颜色
      set-option -g message-style 'fg=#282828, bg=#928374'
      # 复制模式 (Copy mode) 选中文本时的颜色
      set-option -g mode-style 'fg=#282828, bg=#b8bb26'
      # Prefix + q 显示窗格大数字编号时的颜色
      set-option -g display-panes-active-colour '#b8bb26'
      set-option -g display-panes-colour '#928374'
      # Prefix + t 显示全屏时钟的颜色
      set-option -g clock-mode-colour '#b8bb26'
    '';
  };
}

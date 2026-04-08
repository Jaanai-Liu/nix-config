{ pkgs, ... }:

let
  # 远程 SSH 时的特供配置（防套娃冲突）
  # 本地是 Ctrl-b，所以这里让远程机器使用 Ctrl-s 作为前缀键
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

    extraConfig = with pkgs.tmuxPlugins; ''
      # === 插件配置 ===
      run-shell '${copycat}/share/tmux-plugins/copycat/copycat.tmux'
      run-shell '${sensible}/share/tmux-plugins/sensible/sensible.tmux'
      run-shell '${urlview}/share/tmux-plugins/urlview/urlview.tmux'

      # === 快捷键配置 ===
      # 热重载配置文件 (Prefix + 大写 R)
      bind-key R run-shell ' \
        tmux source-file /etc/tmux.conf > /dev/null; \
        tmux display-message "sourced /etc/tmux.conf"'

      # 如果是通过 SSH 连进来的，加载 remoteConf (把前缀变成 Ctrl-s，状态栏放顶部)
      if -F "$SSH_CONNECTION" "source-file '${remoteConf}'"

      # 快速切换窗口 (按住 Ctrl 不放直接按 n 或 p)
      # bind C-n next-window
      # bind C-p previous-window

      # 粘贴时使用 bracketed paste mode (防止缩进错乱)
      bind ] paste-buffer -p

      # 复制 Tmux 缓冲区内容到 Wayland 系统剪贴板 (Prefix + Ctrl-y)
      bind C-y run-shell ' \
        ${pkgs.tmux}/bin/tmux show-buffer > /dev/null 2>&1 \
        && ${pkgs.tmux}/bin/tmux show-buffer | ${pkgs.wl-clipboard}/bin/wl-copy'

      # 分屏时保持当前所在目录 (Prefix + % 或 ")
      bind % split-window -h -c "#{pane_current_path}"
      bind '"' split-window -v -c "#{pane_current_path}"

      # === 行为配置 ===
      set-option -g set-titles on
      set-option -ga terminal-overrides ",*:Tc" # 开启真色彩
      set-option -g mouse on                    # 开启鼠标支持
      set-option -g focus-events on
      set-option -g base-index 1
      set-window-option -g pane-base-index 1
      set-option -g renumber-windows on


      # === 🎨 颜色配置 (Gruvbox 主题) ===
      # 主要用到三种颜色：
      # #282828 -> 深炭灰色 (作为背景色)
      # #b8bb26 -> 明亮的黄绿色 (作为强调色/激活色)
      # #928374 -> 柔和的褐灰色 (作为次要文字颜色)

      set-option -g status-right ' #{prefix_highlight} "#{=21:pane_title}" %H:%M %d-%b-%y'
      set-option -g status-left-length 20

      # Prefix Highlight 插件颜色 (当你按下 Ctrl-b 时状态栏亮起的颜色)
      set-option -g @prefix_highlight_fg '#282828' # 文字：深炭灰色
      set-option -g @prefix_highlight_bg '#b8bb26' # 背景：明亮黄绿色
      run-shell '${prefix-highlight}/share/tmux-plugins/prefix-highlight/prefix_highlight.tmux'

      # 状态栏全局颜色
      set-option -g status-style 'fg=#928374, bg=#282828' # 前景：褐灰色，背景：深炭灰色
      # 当前激活窗口的名字颜色
      set-option -g window-status-current-style 'fg=#b8bb26' # 前景：明亮黄绿色

      # 窗格分界线颜色
      set-option -g pane-border-style 'fg=#282828' # 未激活的边框：深炭灰色 (低调隐藏)
      set-option -g pane-active-border-style 'fg=#b8bb26' # 激活的边框：明亮黄绿色 (高亮显示)

      # 消息提示栏颜色 (比如按下 Prefix + : 输入命令时的底部栏)
      set-option -g message-style 'fg=#282828, bg=#928374' # 文字：深炭灰，背景：褐灰色

      # 复制模式 (Copy mode) 选中文本时的颜色
      set-option -g mode-style 'fg=#282828, bg=#b8bb26' # 文字：深炭灰，高亮背景：明亮黄绿色

      # Prefix + q 显示窗格大数字编号时的颜色
      set-option -g display-panes-active-colour '#b8bb26' # 激活的数字：明亮黄绿色
      set-option -g display-panes-colour '#928374' # 其他数字：褐灰色

      # Prefix + t 显示全屏时钟的颜色
      set-option -g clock-mode-colour '#b8bb26' # 时钟：明亮黄绿色
    '';
  };
}

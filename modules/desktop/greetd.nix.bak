{
  pkgs,
  myvars,
  lib,
  ...
}:
let
  # ==========================================================================
  # 开机会话选择菜单 (greetd session menu)
  #
  # 开机自动登录后显示一个 TUI 菜单（fzf），方向键 + 回车选择要进入的会话：
  #   - niri Desktop      : 日常 niri 桌面
  #   - Steam Big Picture : gamescope 里的 Steam 大屏幕（手柄 UI），当 Steam Deck 主机玩
  #
  # 超时（SESSION_MENU_TIMEOUT 秒）内没有按回车确认时，自动进入 SESSIONS[0]
  # （niri Desktop）。注意：fzf 超时是被 timeout 杀掉的，输出为空，
  # 所以"想进 Steam 大屏幕"必须在超时前方向键选中并按回车。
  #
  # 想改默认项：只需改下面脚本里 SESSIONS 的第一项（case 分支无需改动）。
  # 想改菜单项 / 超时时间：改 SESSIONS 和 SESSION_MENU_TIMEOUT。
  # Steam 大屏幕的启动参数在 modules/desktop/gaming.nix 的 gamescopeSession 里配。
  #
  # 注意：VT 控制台没有中文字体，菜单文字必须用 ASCII，否则显示豆腐块。
  # ==========================================================================
  sessionMenu = pkgs.writeShellApplication {
    name = "greetd-session-menu";
    runtimeInputs = [ pkgs.fzf ];
    text = ''
      # greetd 的 VT 上 TERM 可能未设置，fzf 渲染需要它
      export TERM="''${TERM:-linux}"

      # 菜单选项：第一项 = 超时/取消后自动进入的默认项
      # 切换默认只需改这一行（case 分支不用动）：
      # SESSIONS=("Steam Big Picture" "niri Desktop")
      SESSIONS=("niri Desktop" "Steam Big Picture")
      SESSION_MENU_TIMEOUT=5

      # timeout -k: 先发 TERM 让 fzf 恢复终端后退出；万一被无视，1 秒后 SIGKILL
      # 兜底，保证开机不会卡在菜单上（KILL 留下的屏幕残留无所谓，
      # niri/gamescope 接管 VT 后会立刻重绘）
      choice=$(printf '%s\n' "''${SESSIONS[@]}" \
        | timeout -k 1 "$SESSION_MENU_TIMEOUT" ${pkgs.fzf}/bin/fzf \
            --height 5 \
            --reverse \
            --prompt "Session (auto-start ''${SESSIONS[0]} in ''${SESSION_MENU_TIMEOUT}s) > " \
        || true)

      # 超时或取消时 fzf 输出为空，显式落回默认项（第一项）
      if [ -z "$choice" ]; then
        choice="''${SESSIONS[0]}"
      fi

      case "$choice" in
        "Steam Big Picture")
          # gamescope 里的 Steam 大屏幕（手柄 UI）
          # 未启用 gamescopeSession 时回退到 niri 桌面
          if ! command -v steam-gamescope >/dev/null 2>&1; then
            exec /home/${myvars.username}/.wayland-session
          fi
          export XDG_SESSION_TYPE=wayland
          export XDG_CURRENT_DESKTOP=gamescope
          systemctl --user import-environment XDG_SESSION_TYPE XDG_CURRENT_DESKTOP 2>/dev/null || true
          dbus-update-activation-environment --systemd XDG_SESSION_TYPE XDG_CURRENT_DESKTOP 2>/dev/null || true
          exec /run/current-system/sw/bin/steam-gamescope
          ;;
        *)
          # niri 桌面
          exec /home/${myvars.username}/.wayland-session
          ;;
      esac
    '';
  };
in
{
  security.pam.services.greetd.enableGnomeKeyring = true;
  services.displayManager.gdm.enable = false;
  services.gnome.gnome-keyring.enable = true;

  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        user = myvars.username;

        # 自动登录后跑会话选择菜单：选 niri 或 Steam 大屏幕
        # 旧用法（直接进 niri）：command = "/home/${myvars.username}/.wayland-session";
        command = "${sessionMenu}/bin/greetd-session-menu";
      };
    };
  };

  systemd.services.greetd.serviceConfig = {
    Type = "idle";
    StandardInput = "tty";
    StandardOutput = "tty";
    StandardError = "journal";
    TTYReset = true;
    TTYVHangup = true;
    TTYVTDisallocate = true;
  };
}

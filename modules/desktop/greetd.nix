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
  # 开机自动登录后显示一个 TUI 菜单（gum），方向键 + 回车选择要进入的会话：
  #   - Steam Big Picture : gamescope 里的 Steam 大屏幕（手柄 UI），当 Steam Deck 主机玩
  #   - niri Desktop      : 日常 niri 桌面
  #
  # 超时（SESSION_MENU_TIMEOUT）内没有按回车确认时，自动进入 SESSIONS[0]
  # （Steam Big Picture）。注意：gum 超时不会选中高亮项，所以"想进 niri"
  # 必须在超时前方向键选中并按回车。
  #
  # 想改菜单项 / 默认项 / 超时时间，直接改下面的 SESSIONS 和 SESSION_MENU_TIMEOUT。
  # Steam 大屏幕的启动参数在 modules/desktop/gaming.nix 的 gamescopeSession 里配。
  #
  # 注意：VT 控制台没有中文字体，菜单文字必须用 ASCII，否则显示豆腐块。
  # ==========================================================================
  sessionMenu = pkgs.writeShellApplication {
    name = "greetd-session-menu";
    runtimeInputs = [ pkgs.gum ];
    text = ''
      # greetd 的 VT 上 TERM 可能未设置，gum 渲染需要它
      export TERM="''${TERM:-linux}"

      # 菜单选项：第一项 = 默认高亮（超时后自动进入）
      # SESSIONS=("Steam Big Picture" "niri Desktop")
      SESSIONS=("niri Desktop" "Steam Big Picture")
      SESSION_MENU_TIMEOUT=5s

      choice=$(${pkgs.gum}/bin/gum choose \
        --timeout "$SESSION_MENU_TIMEOUT" \
        --header "Select session (auto-start highlighted one in $SESSION_MENU_TIMEOUT)" \
        --selected "''${SESSIONS[0]}" \
        "''${SESSIONS[@]}" || true)

      case "$choice" in
        "niri Desktop")
          exec /home/${myvars.username}/.wayland-session
          ;;
        *)
          # Steam Big Picture (gamescope session)
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

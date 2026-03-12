{ pkgs, config, inputs, ... }:
let
  # 使用你自己的 Flake 输入获取 Noctalia
  noctalia-pkg = inputs.noctalia.packages.${pkgs.system}.default;
in
{
  home.packages = [
    noctalia-pkg
    pkgs.qt6Packages.qt6ct # 极其重要：用于统一 Qt 程序的图标和主题（Noctalia 是基于 Qt 的）
    pkgs.app2unit          # 允许将桌面程序作为 Systemd 服务启动
  ] ++ (pkgs.lib.optionals pkgs.stdenv.isx86_64 [
    pkgs.gpu-screen-recorder # 一个非常轻量级的 Wayland 录屏工具
  ]);

  xdg.configFile =
    let
      mkSymlink = config.lib.file.mkOutOfStoreSymlink;
      confPath = "${config.home.homeDirectory}/nix-config/home/gui/desktop/niri/noctalia";
    in
    {
      "noctalia".source = mkSymlink "${confPath}/config";
      "qt6ct/qt6ct.conf".source = mkSymlink "${confPath}/qt6ct.conf";
    };

  systemd.user.services.noctalia-shell = {
    Unit = {
      Description = "Noctalia Shell - Wayland desktop shell";
      Documentation = "https://docs.noctalia.dev/docs";
      PartOf = [ "wayland-session.target" ];
      After = [ "wayland-session.target" ];
    };

    Service = {
      ExecStart = "${pkgs.lib.getExe noctalia-pkg}";
      Restart = "on-failure"; # 如果崩溃了，系统会自动帮你拉起来！

      # 注入关键的环境变量，修复 2K 屏缩放和渲染 Bug
      Environment = [
        "QT_QPA_PLATFORM=wayland;xcb"
        "QT_QPA_PLATFORMTHEME=qt6ct"
        "QT_AUTO_SCREEN_SCALE_FACTOR=1"
      ];
    };

    Install = {
      WantedBy = [ "wayland-session.target" ];
    };
  };
}

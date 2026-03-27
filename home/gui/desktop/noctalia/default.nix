{
  pkgs,
  config,
  inputs,
  ...
}:
let
  noctalia-pkg = inputs.noctalia.packages.${pkgs.system}.default;
in
{
  home.packages = [
    noctalia-pkg
    pkgs.qt6Packages.qt6ct
    pkgs.app2unit
  ]
  ++ (pkgs.lib.optionals pkgs.stdenv.isx86_64 [
    pkgs.gpu-screen-recorder
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
      Restart = "on-failure";

      Environment = [
        "QT_QPA_PLATFORM=wayland;xcb"
        "QT_QPA_PLATFORMTHEME=qt6ct"
        "QT_AUTO_SCREEN_SCALE_FACTOR=1"
      ];
    };

    Install.WantedBy = [ "wayland-session.target" ];
  };
}

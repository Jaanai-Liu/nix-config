{ config, pkgs, lib, ... }:

let
  # 在let块中利用pkgs定义自定义的snipaste包
  snipaste-custom = pkgs.appimageTools.wrapType2 rec {
    pname = "snipaste";
    version = "2.10.2";

    src = pkgs.fetchurl {
      url = "https://download.snipaste.com/archives/Snipaste-${version}-x86_64.AppImage";
      hash = "sha256-u9e2d9ZpHDbDIsFkseOdJX2Kspn9TkhFfZxbeielDA8=";
    };

    meta = {
      description = "Screenshot tools";
      homepage = "https://www.snipaste.com/";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
      sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
    };
  };
in
{
  # 1.将这个自定义包加入你的用户环境
  home.packages = [
    snipaste-custom
  ];

  # 2.配置开机自启(强制使用xcb以兼容GNOME Wayland)
  xdg.configFile."autostart/snipaste.desktop".text = ''
    [Desktop Entry]
    Type=Application
    Name=Snipaste
    Exec=env QT_QPA_PLATFORM=xcb ${snipaste-custom}/bin/snipaste
    Terminal=false
    Icon=snipaste
    Categories=Utility;
  '';
}
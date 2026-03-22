{ pkgs, ... }:
let
  # 【核心补丁】包装 udiskie，强行把图标路径塞进它的启动参数里
  udiskie-wrapped = pkgs.symlinkJoin {
    name = "udiskie";
    paths = [ pkgs.udiskie ]; # 基础包
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/udiskie \
        --set XDG_DATA_DIRS "${pkgs.papirus-icon-theme}/share:$XDG_DATA_DIRS" \
        --set GTK_ICON_THEME "Papirus-Dark"
    '';
  };
in
{
  services.udisks2.enable = true;
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
  ];
  environment.systemPackages = with pkgs; [
    ntfs3g # 增强型 NTFS 支持
    exfat # exFAT 支持
    udiskie # 自动挂载守护进程（前端）
    udiskie-wrapped
  ];
  # 3. 【核心】配置 Polkit 权限，允许 myvars.username 用户免密挂载
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        if ((action.id == "org.freedesktop.udisks2.filesystem-mount" ||
             action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
             action.id == "org.freedesktop.udisks2.eject-media" ||
             action.id == "org.freedesktop.udisks2.power-off-drive") &&
            subject.isInGroup("users")) {
            return polkit.Result.YES;
        }
    });
  '';
}

{
  pkgs,
  lib,
  myvars,
  ...
}:
let
  udiskie-wrapped = pkgs.symlinkJoin {
    name = "udiskie";
    paths = [ pkgs.udiskie ];
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
    ntfs3g
    exfat
    #udiskie
    udiskie-wrapped
    papirus-icon-theme
  ];

  # security.polkit.extraConfig = ''
  #   polkit.addRule(function(action, subject) {
  #       if ((action.id == "org.freedesktop.udisks2.filesystem-mount" ||
  #            action.id == "org.freedesktop.udisks2.filesystem-mount-system" ||
  #            action.id == "org.freedesktop.udisks2.eject-media" ||
  #            action.id == "org.freedesktop.udisks2.power-off-drive") &&
  #           subject.isInGroup("users")) {
  #           return polkit.Result.YES;
  #       }
  #   });
  # '';

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
        var YES = polkit.Result.YES;
        var permission = [
            "org.freedesktop.udisks2.filesystem-mount",
            "org.freedesktop.udisks2.filesystem-mount-system",
            "org.freedesktop.udisks2.eject-media",
            "org.freedesktop.udisks2.power-off-drive"
        ];
        if (permission.indexOf(action.id) > -1 && subject.user == "${myvars.username}") {
            return YES;
        }
    });
  '';

  home-manager.users.${myvars.username} = {
    services.udiskie = {
      enable = true;
      # ⚠️ 关键：强制 HM 服务使用我们包装好图标的那个包
      package = udiskie-wrapped;
      tray = "auto";
      notify = true;
    };
  };
}

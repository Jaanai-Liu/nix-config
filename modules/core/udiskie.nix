{
  pkgs,
  lib,
  myvars,
  ...
}:

let
  udiskie-with-icons = pkgs.symlinkJoin {
    name = "udiskie-with-icons";
    paths = [ pkgs.udiskie ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/udiskie \
        --set XDG_DATA_DIRS "${pkgs.papirus-icon-theme}/share:$XDG_DATA_DIRS" \
        --set GTK_ICON_THEME "Papirus-Dark" \
        --add-flags "--notify" 
    '';
  };
in
{
  services.udisks2.enable = true;
  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
  ];

  environment.systemPackages = [
    pkgs.ntfs3g
    pkgs.exfat
    pkgs.papirus-icon-theme
    udiskie-with-icons
  ];

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
    home.sessionVariables = {
      XDG_DATA_DIRS = "$HOME/.nix-profile/share:$XDG_DATA_DIRS";
    };

    services.udiskie = {
      enable = true;
      package = udiskie-with-icons;
      tray = "auto";
      notify = true;
    };

    home.packages = [ pkgs.papirus-icon-theme ];
  };
}

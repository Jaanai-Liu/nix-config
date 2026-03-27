{
  pkgs,
  myvars,
  ...
}:

{
  services.udisks2.enable = true;

  boot.supportedFilesystems = [
    "ntfs"
    "exfat"
  ];

  environment.systemPackages = [
    pkgs.ntfs3g
    pkgs.exfat
  ];

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel") && action.id.startsWith("org.freedesktop.udisks2.")) {
        return polkit.Result.YES;
      }
    });
  '';

  # ==========================================
  # --- Home Manager ---
  # ==========================================
  home-manager.users.${myvars.username} = {
    services.udiskie = {
      enable = true;
      automount = true;
      notify = true;
    };
  };
}

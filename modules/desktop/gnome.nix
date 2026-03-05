{ pkgs, ... }:
{
  # Enable the GNOME Desktop Environment.
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  
  # services.displayManager.gdm.enable = true;
  # services.desktopManager.gnome.enable = true;
  
  #剔除GNOME自带的Epiphany浏览器
  # environment.gnome.excludePackages = [ pkgs.epiphany ];

  # environment.systemPackages = with pkgs; [
  #   gnomeExtensions.power-off-options
  # ];
}
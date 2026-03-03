{ inputs, myvars, ... }:
{
  dconf.settings = {
    # desktop wallpaper
    "org/gnome/desktop/background" = {
      picture-uri = "file:///etc/wallpapers/blood_marry.jpg";
      picture-uri-dark = "file:///etc/wallpapers/blood_marry.jpg"; 
      picture-options = "zoom"; 
    };
    # lock wallpaper
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///etc/wallpapers/lockscreen.jpg";
      picture-options = "zoom";
    };
  };
}
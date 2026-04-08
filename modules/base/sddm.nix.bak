{ pkgs, lib, ... }:

let
  sakuraTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
in
{
  services.greetd.enable = lib.mkForce false;
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;
    package = pkgs.kdePackages.sddm;
    theme = "sddm-astronaut-theme";

    settings = {
      General = {
        InputMethod = "";
        GreeterEnvironment = "QT_SCALE_FACTOR=1.5";
      };
    };

    extraPackages = with pkgs; [
      sakuraTheme
      kdePackages.qtsvg
      kdePackages.qt5compat
      kdePackages.qtdeclarative
      kdePackages.qtmultimedia
    ];
  };

  environment.systemPackages = [ sakuraTheme ];

  security.pam.services.sddm.enableGnomeKeyring = true;
}

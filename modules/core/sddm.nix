{ pkgs, lib, ... }:

let
  # 重新召唤“像素樱花”魔法！
  sakuraTheme = pkgs.sddm-astronaut.override {
    embeddedTheme = "pixel_sakura";
  };
in
{
  # 彻底禁用 greetd
  services.greetd.enable = lib.mkForce false;
  services.xserver.enable = true;

  services.displayManager.sddm = {
    enable = true;

    # 使用纯血 Qt6
    package = pkgs.kdePackages.sddm;

    # 【关键】：主题文件夹的真实名字其实是这个！
    theme = "sddm-astronaut-theme";

    # 【修复虚拟键盘】：将 InputMethod 设为空，就能彻底干掉那个烦人的屏幕键盘
    settings = {
      General = {
        InputMethod = "";
      };
    };

    # 为 SDDM 沙盒注入必备的特效和多媒体渲染库
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

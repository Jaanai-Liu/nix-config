{ pkgs, ... }:
{
  # fcitx5 setting
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      # 确保安装了这两个addon，这对修复位置偏移很重要
      addons = with pkgs; [
        fcitx5-rime
        fcitx5-gtk   # 修复GTK程序(如Firefox, Chrome)的位置
        # fcitx5-qt  # 如果你有QT程序的问题，把这个注释打开
      ];
      
      # 如果你是GNOME或KDE等Wayland环境，加上这行：
      waylandFrontend = true; 
    };
  };

  # 强制设置环境变量，修复“候选框不跟随”的顽疾
  environment.sessionVariables = {
    # 告诉系统尽量使用Fcitx5进行输入
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE = "fcitx";
    XMODIFIERS = "@im=fcitx";
  };

  environment.systemPackages = with pkgs; [
    pkgs.fcitx5-material-color
  ];
}
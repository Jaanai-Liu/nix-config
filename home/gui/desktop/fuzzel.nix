{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "${pkgs.kitty}/bin/kitty";
        layer = "overlay";
        # 精确匹配 Kitty 的字体设置，14px 在 Fuzzel 中通常很大气
        font = "JetBrainsMono Nerd Font:size=14";
        prompt = "󰍉 ";
        icon-theme = "Papirus-Dark";

        # 布局微调：增加一点宽度以适应 JetBrains Mono 的字宽
        width = 30;
        horizontal-pad = 25;
        vertical-pad = 15;
        inner-pad = 12;
        line-height = 28;
        letter-spacing = 0.5;

        fields = "filename,name,generic";
      };

      colors = {
        # 背景使用 Noctalia 风格的深色半透明（末尾 b3 代表约 70% 透明度）
        background = "1e1e2ee6"; # 更加深邃的 Catppuccin Mocha 背景
        text = "cdd6f4ff"; # 浅灰色文字，护眼且高级
        match = "f5c2e7ff"; # 匹配字符高亮（粉色/淡紫色）
        selection = "585b70ff"; # 选中项的背景色
        selection-text = "f5c2e7ff"; # 选中项的文字颜色
        selection-match = "f5c2e7ff";
        # 边框颜色，建议使用 Noctalia 标志性的紫色或蓝色
        border = "b4befeff";
      };

      border = {
        width = 2;
        radius = 15; # 略微调大圆角，更符合现代 Wayland 审美
      };
    };
  };
}


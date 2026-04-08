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

        # 1. 核心修改：使用和 Kitty 类似的字重（SemiBold）会让文字更清晰
        # 提示：Fuzzel 的字体格式建议写为 "Family Weight Size"
        # font = "JetBrainsMono Nerd Font SemiBold:size=14";

        # 2. 解决重叠：在图标后面加 2-3 个空格，给输入框留出空间
        # prompt = "󰍉   ";

        icon-theme = "Papirus-Dark";
        width = 30;
        horizontal-pad = 25;
        vertical-pad = 15;
        inner-pad = 10;
        line-height = 28;

        # 3. 稍微增加字间距，模拟 Kitty 的高级感
        letter-spacing = 0.5;
        fields = "filename,name,generic";
      };

      colors = {
        background = "1e1e2ee6";
        text = "cdd6f4ff";
        match = "f5c2e7ff";
        selection = "585b70ff";
        selection-text = "f5c2e7ff";
        selection-match = "f5c2e7ff";
        border = "b4befeff";
      };

      border = {
        width = 2;
        radius = 15;
      };
    };
  };
}

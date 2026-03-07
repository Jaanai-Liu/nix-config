{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans       #谷歌Noto黑体
      noto-fonts-cjk-serif      #谷歌Noto宋体
      wqy_zenhei                #文泉驿正黑
      wqy_microhei              #文泉驿微米黑
      # 只保留最基础的开源字体包作为兜底
      noto-fonts
      noto-fonts-cjk-sans
      (stdenv.mkDerivation {
        pname = "local-win-fonts";
        version = "1.0";
        src = ../../myfonts;

        installPhase = ''
          mkdir -p $out/share/fonts/truetype
          # 递归查找所有子目录下的字体并拷贝
          find $src -type f \( -name "*.ttf" -o -name "*.TTF" -o -name "*.ttc" -o -name "*.TTC" -o -name "*.otf" -o -name "*.OTF" \) -exec cp {} $out/share/fonts/truetype/ \;
        '';
      })
    ];

    #配置默认字体，确保浏览器优先使用中文字体
    fontconfig = {
      defaultFonts = {
        serif = [ "Noto Serif CJK SC" "Noto Serif" ];
        sansSerif = [ "Noto Sans CJK SC" "Noto Sans" ];
        monospace = [ "Noto Sans Mono CJK SC" "Noto Sans Mono" ];
      };
    };

    # 允许系统扫描这个目录，确保办公软件能找到它们
    fontDir.enable = true;
  };
}
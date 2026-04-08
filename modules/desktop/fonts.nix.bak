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
    fontconfig = {
      defaultFonts = {
        serif = [ "Microsoft YaHei" "Noto Serif CJK SC" "Noto Serif" ];
        sansSerif = [ "Microsoft YaHei" "Noto Sans CJK SC" "Noto Sans" ];
        monospace = [ "Consolas" "Noto Sans Mono CJK SC" "Noto Sans Mono" ];
      };
    };
    fontDir.enable = true;
  };
}
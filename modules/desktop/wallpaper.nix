{ inputs, myvars, ... }:
{
  # 壁纸图片存储到系统的/etc/wallpapers目录下
  environment.etc."wallpapers".source = ../../wallpapers;
}
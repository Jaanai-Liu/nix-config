{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      mkScriptsPackage =
        name: src:
        prev.stdenvNoCC.mkDerivation {
          inherit name src;
          dontUnpack = true;
          # setSourceRoot = "sourceRoot=`pwd`";
          installPhase = ''
            install -dm 755 $out/bin
            if [ -f $src ]; then
              install -m 755 -t $out/bin $src
            else
              install -m 755 -t $out/bin $src/*
            fi
          '';
        };
      mkFontPackage =
        name: src:
        prev.stdenvNoCC.mkDerivation {
          inherit name src;
          dontUnpack = true;
          installPhase = ''
            mkdir -p $out/share/fonts/{cus_opentype,cus_truetype,misc}
            find ${src} -name "*.otf" -exec cp {} $out/share/fonts/cus_opentype/ \;
            find ${src} -name "*.otb" -exec cp {} $out/share/fonts/cus_opentype/ \;
            find ${src} -name "*.ttf" -exec cp {} $out/share/fonts/cus_truetype/ \;
            find ${src} -name "*.ttc" -exec cp {} $out/share/fonts/cus_truetype/ \;
            find ${src} -name "*.bdf" -exec cp {} $out/share/fonts/misc/ \;

            rmdir $out/share/fonts/cus_opentype $out/share/fonts/cus_truetype $out/share/fonts/misc --ignore-fail-on-non-empty
          '';
        };
    })
  ];
}

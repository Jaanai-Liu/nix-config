{
  pkgs,
  lib,
  ...
}:

{
  packages = with pkgs; [
    git
    nodejs_22
    pnpm
  ];

  enterShell = ''
    echo "🚀 NixOS Config Dev Environment loaded!"
    node -v
    pnpm -v
    echo ""
    echo "  Blog source: modules/server/web-server/blog/"
    echo "  Build:  cd modules/server/web-server/blog && pnpm install && pnpm run build"
    echo "  Deploy: colmena apply --on lz-ali boot"
    echo ""
  '';
}

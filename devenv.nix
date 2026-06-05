{
  pkgs,
  lib,
  ...
}:

{
  packages = with pkgs; [
    git
    nodejs_22  # currently 22.22.3
    pnpm       # currently 11.1.2
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

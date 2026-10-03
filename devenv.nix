{
  pkgs,
  lib,
  ...
}:

{
  packages = with pkgs; [
    git
    nodejs_22 # currently 22.22.3
    pnpm # currently 11.1.2
  ];

  enterShell = ''
    echo "🚀 NixOS Config Dev Environment loaded!"
    echo ""
  '';
}

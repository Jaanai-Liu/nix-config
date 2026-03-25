{
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    colmena # nixos's remote deployment tool
  ];

}

{
  pkgs,
  ...
}:
{
  environment.systemPackages = with pkgs; [
    ventoy
  ];

  nixpkgs.config.permittedInsecurePackages = [
    "ventoy-${pkgs.ventoy.version}"
  ];

  # nixpkgs.config.allowInsecurePredicate =
  #   pkg:
  #   builtins.elem (lib.getName pkg) [
  #     "ventoy"
  #   ];
}

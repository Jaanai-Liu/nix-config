{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      udiskie = prev.udiskie.overrideAttrs (old: {
        doCheck = false;
      });
    })
  ];
}

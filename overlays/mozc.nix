{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      mozc = prev.mozc.overrideAttrs (old: {
        postPatch = (old.postPatch or "") + ''
          find . -name '*.ui' -exec sed -i 's/::mozc::/mozc::/g' {} +
        '';
      });
    })
  ];
}

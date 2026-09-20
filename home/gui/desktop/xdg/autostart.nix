{
  pkgs,
  lib,
  ...
}:
{
  # XDG autostart entries - ensures apps start after portal services are ready
  xdg.autostart.enable = true;
  # This fixes nixpak sandboxed apps (like firefox) accessing mapped folders correctly
  xdg.autostart.entries = [
    # browser
    "${pkgs.firefox}/share/applications/firefox.desktop"
    # proxy
    "${pkgs.clash-verge-rev}/share/applications/clash-verge.desktop"
    # input method
    "${pkgs.fcitx5}/share/applications/org.fcitx.Fcitx5.desktop"
    # music player
    "${pkgs.splayer-next}/share/applications/top.imsyy.splayer_next.desktop"
    # terminal
    "${pkgs.kitty}/share/applications/kitty.desktop"
    # "${pkgs.flameshot}/share/applications/org.flameshot.Flameshot.desktop"
  ];
  # ++ (
  #   if pkgs.stdenv.isx86_64 then
  #     [ "${pkgs.google-chrome}/share/applications/google-chrome.desktop" ]
  #   else
  #     [ "${pkgs.chromium}/share/applications/chromium-browser.desktop" ]
  # );
}

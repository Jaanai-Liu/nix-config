{
  config,
  pkgs,
  ...
}:
let
  flypy-data = pkgs.runCommandLocal "rime-data-flypy" { } ''
    mkdir -p $out/share/rime-data
    cp -r ${./rime-data-flypy}/* $out/share/rime-data/
  '';
in
{
  xdg.configFile = {
    "fcitx5/profile" = {
      source = ./profile;
      # every time fcitx5 switch input method, it will modify ~/.config/fcitx5/profile,
      # so we need to force replace it in every rebuild to avoid file conflict.
      force = true;
    };
    "mozc/config1.db".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/home/linux/gui/base/fcitx5/mozc-config1.db";

    # theme
    "fcitx5/conf/classicui.conf" = {
      text = ''
        Vertical Candidate List=False
        WheelForPaging=True
        Font="Noto Sans CJK SC 10"
        Theme=catppuccin-macchiato-mauve
      '';
      force = true;
    };
  };

  # Rime ice
  xdg.dataFile = {
    "fcitx5/rime/default.custom.yaml".text = ''
      patch:
        schema_list:
          - schema: rime_ice
          - schema: double_pinyin_flypy
          - schema: flypy
    '';
    "fcitx5/rime/rime_ice.custom.yaml".text = ''
      patch:
        "menu/page_size": 9
    '';
    "fcitx5/rime/flypy.custom.yaml".text = ''
      patch:
        "menu/page_size": 9
    '';
  };

  home.packages = with pkgs; [
    lxgw-wenkai
  ];

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      qt6Packages.fcitx5-configtool # GUI for fcitx5
      fcitx5-gtk # gtk im module

      # Chinese
      fcitx5-rime # for flypy chinese input method && rime-ice

      # Japanese
      # ctrl-i / F7 - convert to takakana
      # ctrl-u / F6 - convert to hiragana
      fcitx5-mozc-ut # Moze with UT dictionary

      # Korean
      fcitx5-hangul

      # fcitx5-material-color
      catppuccin-fcitx5
    ];
  };
}

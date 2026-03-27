{
  pkgs,
  config,
  ...
}:
# processing audio/video
{
  home.packages = with pkgs; [
    # audio control
    pavucontrol
    playerctl
    pulsemixer

    # ffmpeg-full
    ffmpeg

    # images
    imv # Simple image viewer
    vimiv-qt # A better vim-like image viewer
    viu # Terminal image viewer with native support for iTerm and Kitty
    imagemagick
    graphviz

    gimp # ps in linux
    krita

    # video/audio tools
    libva-utils
    vdpauinfo
    vulkan-tools
    mesa-demos

    darktable # pr in linux
    rawtherapee

    # lx-music-desktop

    # video
    kdePackages.kdenlive
    vlc
  ];

  programs = {
    # live streaming
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        # screen capture
        wlrobs
        # obs-ndi
        obs-vaapi
        # obs-nvfbc
        obs-teleport
        # obs-hyperion
        # droidcam-obs
        # obs-vkcapture
        # obs-gstreamer
        # obs-3d-effect
        # input-overlay
        # obs-multi-rtmp
        # obs-source-clone
        # obs-shaderfilter
        obs-source-record
        # obs-livesplit-one
        # looking-glass-obs
        # obs-vintage-filter
        # obs-command-source
        # obs-move-transition
        # obs-backgroundremoval
        # advanced-scene-switcher
        # obs-pipewire-audio-capture
      ];
    };
  };

  programs = {
    mpv = {
      enable = true;
      defaultProfiles = [ "gpu-hq" ];
      scripts = with pkgs.mpvScripts; [
        mpris
        encode
        mpv-cheatsheet
        uosc
        thumbfast
      ];
      config = {
        osd-bar = "no";
        border = "no";
        save-position-on-quit = true; # 退出时自动保存位置
        watch-later-directory = "~/.cache/mpv/watch_later"; # 指定保存进度的目录
      };
      bindings = {
        space = "cycle pause; script-binding uosc/flash-pause-indicator";
        right = "seek 5; script-binding uosc/flash-timeline";
        left = "seek -5; script-binding uosc/flash-timeline";
        "shift+right" = "seek 30; script-binding uosc/flash-timeline";
        "shift+left" = "seek -30; script-binding uosc/flash-timeline";
        m = "no-osd cycle mute; script-binding uosc/flash-volume";
        up = "no-osd add volume 10; script-binding uosc/flash-volume";
        down = "no-osd add volume -10; script-binding uosc/flash-volume";
        "[" = "no-osd add speed -0.1; script-binding uosc/flash-speed";
        "]" = "no-osd add speed 0.1; script-binding uosc/flash-speed";
        "\\" = "no-osd set speed 1; script-binding uosc/flash-speed";
        ">" = "script-binding uosc/next; script-message-to uosc flash-elements top_bar,timeline";
        "<" = "script-binding uosc/prev; script-message-to uosc flash-elements top_bar,timeline";
      };
    };
  };

  services.playerctld.enable = true;
  services.mpris-proxy.enable = true;

  # home.packages = [ pkgs.vlc ];
  home.file.".config/vlc/vlcrc".text = ''
    # 弹窗禁止
    qt-privacy-ask=0

    # network
    metadata-network-access=1

    ### 自动恢复播放进度
    # 0 = 从不, 1 = 询问, 2 = 总是
    qt-continue=2

    [core]
    # 自动优先选择中文字幕
    sub-language=chi,zh,zh-cn,chs,sc

    # 自动优先选择中文音轨（可选，建议也加上）
    audio-language=chi,zh,zh-cn,chs,sc

    # 自动检测并加载同名字幕文件
    sub-autodetect-file=1
    # 模糊匹配字幕（例如视频名和字幕名不完全一致时也能加载）
    sub-autodetect-fuzzy=1
  '';
}

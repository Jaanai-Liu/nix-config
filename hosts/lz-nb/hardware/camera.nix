# Camera: Bison Electronics Inc. Integrated RGB Camera (USB 5986:215d)
#   lsusb | grep -i camera
#   cat /sys/class/video4linux/*/name
#
# This is a standard USB UVC camera — no kernel drivers or firmware needed.
# Face unlock via Howdy (Windows Hello™-style).
#
# NOTE: This is an RGB camera (not IR). Howdy can be fooled by a printed photo;
#   by default the PAM control is "required" (second-factor), not "sufficient".
#
# After rebuild, enroll your face:  sudo howdy add
# Test (with preview window):       sudo -E howdy test
# Test (headless):                  sudo howdy test --plain

{ ... }:

{
  # Face unlock — install howdy and register the PAM module on all services.
  services.howdy.enable = true;

  # Camera device path. /dev/video2 is the main video capture interface on this machine.
  # To list devices: cat /sys/class/video4linux/*/name
  services.howdy.settings = {
    video.device_path = "/dev/video2";
  };

  # Preserve display env vars so `sudo -E howdy test` can open the GTK preview window.
  security.sudo.extraConfig = ''
    Defaults env_keep += "DISPLAY WAYLAND_DISPLAY XAUTHORITY XDG_RUNTIME_DIR"
  '';
}

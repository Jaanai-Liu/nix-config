# Camera: Bison Electronics Inc. Integrated RGB Camera (USB 5986:215d)
#   lsusb | grep -i camera
#   cat /sys/class/video4linux/*/name
#
# This is a standard USB UVC camera — no kernel drivers or firmware needed.
# Face unlock via Howdy (Windows Hello™-style).
#
# NOTE: This is an RGB camera (not IR). Howdy can be fooled by a printed photo;
#   by default the PAM control is "required" (second-factor), not "sufficient".

{ ... }:

{
  # Face unlock — install howdy and register the PAM module on all services.
  services.howdy.enable = true;

  # Camera device path. /dev/video2 is the main video capture interface on this machine.
  # To list devices: cat /sys/class/video4linux/*/name
  services.howdy.settings = {
    video.device_path = "/dev/video2";
  };
}

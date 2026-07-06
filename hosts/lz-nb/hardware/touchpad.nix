# 装完系统后，用以下命令确认触摸板型号，再取消注释并调整：
#   cat /proc/bus/input/devices | grep -i -A5 touchpad
#   libinput list-devices | grep -i -A10 touchpad
#
# { lib, config, ... }:
# {
#   services.xserver.libinput.enable = true;
#   services.xserver.libinput.touchpad = {
#     naturalScrolling = true;
#     tapping = true;
#   };
# }
{}

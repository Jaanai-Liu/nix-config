# Touchpad configuration via libinput.
# Diagnose hardware: cat /proc/bus/input/devices | grep -i -A5 touchpad
#                    libinput list-devices | grep -i -A10 touchpad
{
  lib,
  config,
  ...
}:
{
  services.libinput.enable = true;
  services.libinput.touchpad = {
    naturalScrolling = true;
    tapping = true;
    tappingButtonMap = "lrm"; # 1-finger=left, 2-finger=right, 3-finger=middle
    accelProfile = "adaptive"; # "flat" for no acceleration
    accelSpeed = "0.3"; # Slightly reduced for precision (default 0.0, range -1..1)
    scrollMethod = "twofinger";
    horizontalScrolling = true;
    disableWhileTyping = true;
    clickMethod = "clickfinger"; # 2-finger right click, 3-finger middle click
    middleEmulation = false;
    # dragLock = false; # Uncomment to lock drag gesture
  };
}

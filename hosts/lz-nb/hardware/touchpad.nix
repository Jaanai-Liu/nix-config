{ lib, config, ... }:
{
  # TODO: 笔记本装完后，根据实际触摸板型号调整
  services.xserver.libinput.enable = true;
  services.xserver.libinput.touchpad = {
    naturalScrolling = true;
    tapping = true;
  };
}

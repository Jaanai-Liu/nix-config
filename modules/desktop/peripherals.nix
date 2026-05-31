{ pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver.enable = true;
  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ============================= Printer =============================
  # Enable CUPS to print documents.
  services.printing.enable = true;
  # HP DeskJet 2130 (USB wired) — print + scan
  services.printing.drivers = [ pkgs.hplip ];
  hardware.sane = {
    enable = true;
    extraBackends = [ pkgs.hplip ];
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # services.pipewire.extraConfig.pipewire."92-low-latency" = {
  #   "context.properties" = {
  #     "default.clock.rate" = 48000;
  #     "default.clock.quantum" = 1024;
  #     "default.clock.min-quantum" = 32;
  #     "default.clock.max-quantum" = 2048;
  #   };
  # };

  # Enable networking
  networking.networkmanager.enable = true;

  #============================= Bluetooth =============================
  # enable bluetooth & gui paring tools - blueman
  # or you can use cli:
  # $ bluetoothctl
  # [bluetooth] # power on
  # [bluetooth] # agent on
  # [bluetooth] # default-agent
  # [bluetooth] # scan on
  # ...put device in pairing mode and wait [hex-address] to appear here...
  # [bluetooth] # pair [hex-address]
  # [bluetooth] # connect [hex-address]
  # Bluetooth devices automatically connect with bluetoothctl as well:
  # [bluetooth] # trust [hex-address]
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # ( Performance/Balanced/Power Saver ）
  services.power-profiles-daemon.enable = true;
  # battery
  services.upower.enable = true;

  services.envfs.enable = true;
}

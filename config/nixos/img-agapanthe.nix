#
# Main module for `img-agapanthe` config.
#
{ config, lib, pkgs, ... }:

{

  imports = [
    ./modules/dotses
    ./modules/generic
  ];

  # By default Nix won't install packages that have a non-free software
  # license. We need a couple of those (see notes down below) so we have
  # to override the default setting to force Nix to install them.
  nixpkgs.config.allowUnfree = true;

  # Set host name.
  networking.hostName = "img-agapanthe";

  ##############################################################################
  # Wireless keyboard and trackpad settings.
  # NB you'll need to do the pairing manually before you can use them.
  # The udev rule is for automatically connect them at boot time.
  # See: https://wiki.archlinux.org/index.php/Bluetooth
  hardware.bluetooth.enable = true;
  services.udev.extraRules = ''
    ACTION=="add", KERNEL=="hci0", RUN+="/run/current-system/sw/bin/hciconfig %k up"
  '';

  # X: use NVidia driver, tweak trackpad, and add a composite manager.
  services.xserver = {
    videoDrivers = [ "nvidia" ];  # requires allowUnfree

    libinput = {
      enable = true;

      tapping = true;               # default
      buttonMapping = "1 2 3";
      # i.e. 1-finger tap = click; 2-finger tap = right click;
      # 3-finger tap = middle button (useful to paste in xterm)

      naturalScrolling = true;
      scrollMethod = "twofinger";   # default
      tappingDragLock = true;       # default
    };
  };
  services.compton = {
    enable = true;
    fade = true;
    inactiveOpacity = "0.9";
    menuOpacity = "0.95";
  };

  # Create my usual admin user with initial password of `abc123` and build
  # a bare-bones desktop for him, with automatic login.
  ext.youdesk = {
    enable = true;
    username = "andrea";
  };
  # Use Numix theme. (NOTE remove if you enable i3g.)
  ext.gtk3.users = [ config.users.extraUsers.andrea ];
  ext.numix.enable = true;

  ext.java.dev.enable = true;
  ext.git.config.user = config.users.users.andrea;

  environment.systemPackages = with pkgs; [
    google-chrome # requires allowUnfree
    # (samba.override { enablePrinting = true; }) system-config-printer
    samba
  ];

  # Tell i3 to use our Google Chrome.
  ext.i3.config.browser = "google-chrome-stable";

/*
  services.printing.enable = true;
  services.printing.extraConf = ''
    LogLevel debug
  '';
  services.printing.drivers = [ (import ./pkgs/cups/toshiba-e-studio5005ac) ];
  services.samba.enable = true;
  */
}

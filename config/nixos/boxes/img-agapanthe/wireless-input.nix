#
# Wireless input devices configuration.
# This module connects my Apple wireless keyboard and magic trackpad
# through bluetooth. For this to work, you'll first have to do the
# pairing yourself with `bluetoothctl`. The devices MACs and names
# are:
#           MAC                   Name
#     -----------------     -----------------
#     E8:80:2E:E6:6C:43     andrea’s Trackpad
#     B8:09:8A:F3:FB:0B     andrea’s Keyboard
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    ext.wireless-input.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to connect bluetooth devices and get default trackpad
        settings with natural scrolling.
      '';
    };
  };

  config = let
    enabled = config.ext.wireless-input.enable;
    hciconfig = "/run/current-system/sw/bin/hciconfig";
  in (mkIf enabled {
    # First enable bluetooth.
    hardware.bluetooth.enable = true;

    # This udev rule is for connecting bluetooth devices automatically at
    # boot time. See:
    # - https://wiki.archlinux.org/index.php/Bluetooth
    #
    services.udev.extraRules = ''
      ACTION=="add", KERNEL=="hci0", RUN+="${hciconfig} %k up"
    '';

    # Tweak trackpad for use with X.
    ext.trackpad.enable = true;
  });

}

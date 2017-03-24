#
# Trackpad settings.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    ext.trackpad.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables default trackpad settings and uses natural scrolling.
        Use this module if you have a trackpad. Note that these settings
        are ignored by GNOME, so if you're using GNOME you'll have to
        replicate these settings through the Tweak Tool.
      '';
    };
  };

  config = let
    enabled = config.ext.trackpad.enable;
  in
  {
    services.xserver.libinput = mkIf enabled {
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

}

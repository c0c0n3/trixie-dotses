#
# GNOME 3 touchpad settings.
# Any config option below can be null in which case it's ignored. If you want
# to clear the corresponding setting in the GNOME config DB, set the option to
# an empty string or list as the case may be.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ./utils.nix;
{

  options = {
    ext.gnomix.gsettings.touchpad.tap-to-click = mkOption {
      type = nullOr bool;
      default = null;
      description = ''
        If true, you can tap on the touchpad to click.
      '';
    };
    ext.gnomix.gsettings.touchpad.natural-scrolling = mkOption {
      type = nullOr bool;
      default = null;
      description = ''
        If true, you can use natural scrolling with the touchpad.
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.gsettings.touchpad;

    script = setIfFragment "Touchpad" {  # NOTE (2)
      "org.gnome.desktop.peripherals.touchpad tap-to-click" =
        cfg.tap-to-click;
      "org.gnome.desktop.peripherals.touchpad natural-scroll" =
        cfg.natural-scrolling;
    };
  in {  # NOTE (1)
    # Add a fragment to the gsettings script to store our settings into the
    # GNOME config DB.
    ext.gnomix.gsettings.script.lines.touchpad = script;

    # Specify the schema gsettings is going to need to set our config values.
    ext.gnomix.gsettings.script.xdg-data-dirs = with pkgs.gnome3; [
      gsettings_desktop_schemas
    ];
  };

}
# Notes
# -----
# 1. Enabling Config. Pointless to add an "enabled" check here. Blindly add
# lines to the script: if gnomix.config.enable == false nothing happens.
#
# 2. Null values. The scriptFragment function skips them, so if null, the
# option's value isn't set in the GNOME DB.

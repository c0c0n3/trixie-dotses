#
# GNOME 3 appearance settings.
# Any config option below can be null in which case it's ignored. If you want
# to clear the corresponding setting in the GNOME config DB, set the option to
# an empty string or list as the case may be.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ./utils.nix;
{
  # TODO get rid of default values. move default config to gnomix/default.nix?

  options = {
    ext.gnomix.gsettings.wallpaper = mkOption {
      type = nullOr path;
      default = null;
      description = ''
        Absolute pathname of the wallpaper picture to use both for the
        desktop and the screensaver.
      '';
    };
    ext.gnomix.gsettings.fonts.window-titles = mkOption {
      type = nullOr string;
      default = "Ubuntu Medium 11";
      description = ''
        Window titles font.
      '';
    };
    ext.gnomix.gsettings.fonts.interface = mkOption {
      type = nullOr string;
      default = "Ubuntu Regular 13";
      description = ''
        Interface font.
      '';
    };
    ext.gnomix.gsettings.fonts.documents = mkOption {
      type = nullOr string;
      default = "Ubuntu Regular 13";
      description = ''
        Documents font.
      '';
    };
    ext.gnomix.gsettings.fonts.monospace = mkOption {
      type = nullOr string;
      default = "Ubuntu Mono Regular 15";
      description = ''
        Monospace font.
      '';
    };
    ext.gnomix.gsettings.gtk-theme = mkOption {
      type = nullOr string;
      default = "Numix";
      description = ''
        GTK theme.
      '';
    };
    ext.gnomix.gsettings.icon-theme = mkOption {
      type = nullOr string;
      default = "Numix-Circle";
      description = ''
        Icon theme.
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.gsettings;

    script = setIfFragment "Look & Feel" {  # NOTE (2)
      "org.gnome.desktop.background picture-uri" = cfg.wallpaper;
      "org.gnome.desktop.screensaver picture-uri" = cfg.wallpaper;
      "org.gnome.desktop.interface font-name" = cfg.fonts.interface;
      "org.gnome.desktop.interface document-font-name" = cfg.fonts.documents;
      "org.gnome.desktop.interface monospace-font-name" = cfg.fonts.monospace;
      "org.gnome.desktop.wm.preferences titlebar-font" = cfg.fonts.window-titles;
      "org.gnome.desktop.interface gtk-theme" = cfg.gtk-theme;
      "org.gnome.desktop.interface icon-theme" = cfg.icon-theme;
    };
  in {  # NOTE (1)
    # Add a fragment to the gsettings script to store our settings into the
    # GNOME config DB.
    ext.gnomix.gsettings.script.lines.look-n-feel = script;

    # Specify the schema gsettings is going to need to set our config values.
    ext.gnomix.gsettings.script.xdg-data-dirs = with pkgs.gnome3; [
      gsettings_desktop_schemas
    ];
  };

}
# Notes
# -----
# 1. Enabling Config. Pointless to add an "enabled" check here. Blindly add
# lines to the script: if gsettings.enable == false nothing happens.
# 2. Null values. The scriptFragment function skips them, so if null, the
# option's value isn't set in the GNOME DB.

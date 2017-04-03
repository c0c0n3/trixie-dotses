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
      default = null;
      description = ''
        Window titles font.
      '';
    };
    ext.gnomix.gsettings.fonts.interface = mkOption {
      type = nullOr string;
      default = null;
      description = ''
        Interface font.
      '';
    };
    ext.gnomix.gsettings.fonts.documents = mkOption {
      type = nullOr string;
      default = null;
      description = ''
        Documents font.
      '';
    };
    ext.gnomix.gsettings.fonts.monospace = mkOption {
      type = nullOr string;
      default = null;
      description = ''
        Monospace font.
      '';
    };
    ext.gnomix.gsettings.gtk-theme = mkOption {
      type = nullOr string;
      default = null;
      description = ''
        GTK theme.
      '';
    };
    ext.gnomix.gsettings.gtk-theme-prefer-dark = mkOption {
      type = nullOr bool;
      default = null;
      description = ''
        Should GTK use the dark theme variant if available?
      '';
    };
    ext.gnomix.gsettings.icon-theme = mkOption {
      type = nullOr string;
      default = null;
      description = ''
        Icon theme.
      '';
    };
    ext.gnomix.gsettings.clock-show-date = mkOption {
      type = nullOr bool;
      default = null;
      description = ''
        Wanna see the date too on the status bar?
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.gsettings;

    script1 = setIfFragment "Look & Feel" {  # NOTE (2)
      "org.gnome.desktop.background picture-uri" = cfg.wallpaper;
      "org.gnome.desktop.screensaver picture-uri" = cfg.wallpaper;
      "org.gnome.desktop.interface font-name" = cfg.fonts.interface;
      "org.gnome.desktop.interface document-font-name" = cfg.fonts.documents;
      "org.gnome.desktop.interface monospace-font-name" = cfg.fonts.monospace;
      "org.gnome.desktop.wm.preferences titlebar-font" = cfg.fonts.window-titles;
      "org.gnome.desktop.interface gtk-theme" = cfg.gtk-theme;
      "org.gnome.desktop.interface icon-theme" = cfg.icon-theme;
      "org.gnome.desktop.interface clock-show-date" = cfg.clock-show-date;
    };
    script2 = if cfg.gtk-theme-prefer-dark == null then ""
    else ''
      mkdir -p $HOME/.config/gtk-3.0
      cat <<EOF > $HOME/.config/gtk-3.0/settings.ini
      [Settings]
      gtk-application-prefer-dark-theme=${if cfg.gtk-theme-prefer-dark
                                          then "1" else "0"}
      EOF
    ''; # NOTE (3)
  in {  # NOTE (1)
    # Add a fragment to the gsettings script to store our settings into the
    # GNOME config DB.
    ext.gnomix.gsettings.script.lines.look-n-feel = script1 + script2;

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
#
# 3. GTK dark theme. This is a funny one. If you specify a theme name or icons
# in `settings.ini` GNOME ignores it. In fact, these values are stored in the
# GSettings DB. But there doesn't seem to be a key for the dark theme which is
# probably why the Tweak Tool writes this setting to `settings.ini`. So we're
# doing the same.

#
# GNOME 3 desktop settings.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    ext.gsettings.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install a script that'll let you load these settings
        into the GNOME configuration database. The script will be in your
        PATH; run it to load the settings.
      '';
    };
    ext.gsettings.cmd-name = mkOption {
      type = string;
      default = "gnomix-settings.load";
      description = ''
        The name of the script to load the settings.
      '';
    };
    ext.gsettings.wallpaper = mkOption {
      type = string;
      default = "";
      description = ''
        Absolute pathname of the wallpaper picture to use both for the
        desktop and the screensaver.
      '';
    };
    ext.gsettings.fonts.window-titles = mkOption {
      type = string;
      default = "Ubuntu Medium 11";
      description = ''
        Window titles font.
      '';
    };
    ext.gsettings.fonts.interface = mkOption {
      type = string;
      default = "Ubuntu Regular 13";
      description = ''
        Interface font.
      '';
    };
    ext.gsettings.fonts.documents = mkOption {
      type = string;
      default = "Ubuntu Regular 13";
      description = ''
        Documents font.
      '';
    };
    ext.gsettings.fonts.monospace = mkOption {
      type = string;
      default = "Ubuntu Mono Regular 15";
      description = ''
        Monospace font.
      '';
    };
    ext.gsettings.appearance.gtk-theme = mkOption {
      type = string;
      default = "Numix";
      description = ''
        GTK theme.
      '';
    };
    ext.gsettings.appearance.icon-theme = mkOption {
      type = string;
      default = "Numix-Circle";
      description = ''
        Icon theme.
      '';
    };
    ext.gsettings.appearance.shell-theme = mkOption {
      type = string;
      default = "Flat Remix";
      description = ''
        GNOME Shell theme.
      '';
    };
    ext.gsettings.touchpad.tap-to-click = mkOption {
      type = bool;
      default = true;
      description = ''
        If true, you can tap on the touchpad to click.
      '';
    };
    ext.gsettings.touchpad.natural-scrolling = mkOption {
      type = bool;
      default = true;
      description = ''
        If true, you can use natural scrolling with the touchpad.
      '';
    };
  };

#     # Tell gsettings where to find the schemas.
#      export XDG_DATA_DIRS="${desktop-schemas}:$XDG_DATA_DIRS";

  config = let
    cfg = config.ext.gsettings;

    bash = "${pkgs.bashInteractive}/bin/bash";
    set = "${pkgs.glib.dev}/bin/gsettings set";
#    desktop-schemas = "/run/current-system/sw/share/gsettings-schemas/" +
#                      "${pkgs.gnome3.gsettings_desktop_schemas.name}";

    toBool = b : if b then "true" else "false";
    schema-path = pkg : "/run/current-system/sw/share/gsettings-schemas/" +
                        "${pkg.name}";  # NOTE (2)

    script = pkgs.writeScriptBin cfg.cmd-name ''
      #!${bash}

      # Look & Feel
      ${set} org.gnome.desktop.background picture-uri '${cfg.wallpaper}'
      ${set} org.gnome.desktop.screensaver picture-uri '${cfg.wallpaper}'
      ${set} org.gnome.desktop.interface font-name '${cfg.fonts.interface}'
      ${set} org.gnome.desktop.interface document-font-name '${cfg.fonts.documents}'
      ${set} org.gnome.desktop.interface monospace-font-name '${cfg.fonts.monospace}'
      ${set} org.gnome.desktop.wm.preferences titlebar-font '${cfg.fonts.window-titles}'
      ${set} org.gnome.desktop.interface gtk-theme '${cfg.appearance.gtk-theme}'
      ${set} org.gnome.desktop.interface icon-theme '${cfg.appearance.icon-theme}'
      ${set} org.gnome.shell.extensions.user-theme name '${cfg.appearance.shell-theme}'

      # Touchpad
      ${set} org.gnome.desktop.peripherals.touchpad tap-to-click ${toBool cfg.touchpad.tap-to-click}
      ${set} org.gnome.desktop.peripherals.touchpad natural-scroll ${toBool cfg.touchpad.natural-scrolling}

      # Opinionated key bindings
      for i in {1..10}
      do
        ${set} org.gnome.desktop.wm.keybindings switch-to-workspace-"$i" "['<Super>$((i % 10))']"
        ${set} org.gnome.desktop.wm.keybindings move-to-workspace-"$i" "['<Super><Shift>$((i % 10))']"
      done

  '';
  in (mkIf cfg.enable
  {
    environment.systemPackages = with pkgs; [
      glib glib.dev gnome3.gsettings_desktop_schemas
      script
    ];
    environment.variables = with pkgs; {
      #XDG_DATA_DIRS = "${desktop-schemas}";  # NOTE (2) (3)
      XDG_DATA_DIRS =                                          # NOTE (2) (3)
        "${schema-path gnome3.gsettings_desktop_schemas}" +
        ":${schema-path gnome3.gnome-shell-extensions}";  # TODO not the right one for
                                                          # org.gnome.shell.extensions.user-theme
                                                          # probably comes with user theme ext
                                                          # which I'll have to pkg myself...
    };
  });

}
# Notes
# -----
# 1. GNOME Settings. This is how I figured out the lay of the land:
#  * Specify settings with Tweak Tool
#  * Find corresponding key/values in dConf UI
#  * Dump DB paths containing all keys you're interested in:
#
#     $ dconf dump /org/gnome/desktop/ > org.gnome.desktop
#     $ dconf dump /org/gnome/shell/ > org.gnome.shell
#
# 2. GSettings Schemas. Looks like NixOS sym-links them under
#
#     /run/current-system/sw/share/gsettings-schemas
#
# e.g. you'll find `gsettings-desktop-schemas-3.20.0` in there among others.
# Each of these dirs should be added to $XDG_DATA_DIRS for `gsettings` to
# be able to find the corresponding schema though. In fact,
#  "At runtime, GSettings looks for schemas in the glib-2.0/schemas
#   subdirectories of all directories specified in the XDG_DATA_DIRS
#   environment variable."
# Straight from the horse's mouth. For some reason NixOS isn't doing it,
# which is why I'm doing it myself here. But there's possibly better ways
# to go about this. I've seen a $GSETTINGS_SCHEMAS_PATH variable used all
# over the show in the GNOME packages, didn't have time to dig deeper though...
#
# 3. Merging of $XDG_DATA_DIRS. NixOS does that for you, so this
#
#     XDG_DATA_DIRS = "$XDG_DATA_DIRS:${desktop-schemas}";
#
# actually results in duplicating path entries in $XDG_DATA_DIRS.

#
# GNOME 3 desktop settings.
#
{ config, lib, pkgs, ... }:

with lib;
with types;

let
  user-theme = (import ../../pkgs/gnome-shell-exts/user-theme);
  flat-remix = (import ../../pkgs/themes/flat-remix-gnome-theme.nix);
  shelltile  = (import ../../pkgs/gnome-shell-exts/shelltile.nix);
  dyntopbar  = (import ../../pkgs/gnome-shell-exts/dynamictopbar.nix);
in
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
      type = package;
      default = flat-remix;
      description = ''
        GNOME Shell theme.
      '';
    };
    ext.gsettings.shell.extensions = mkOption {
      type = listOf string;
      default = [
        user-theme.uuid shelltile.uuid dyntopbar.uuid
        "launch-new-instance@gnome-shell-extensions.gcampax.github.com" ];
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

  config = let
    cfg = config.ext.gsettings;

    bash = "${pkgs.bashInteractive}/bin/bash";
    set = "${pkgs.glib.dev}/bin/gsettings set";

    toBool = b : if b then "true" else "false";
    schema-path = pkg : "/run/current-system/sw/share/gsettings-schemas/" +
                        "${pkg.name}";  # NOTE (2) (3)
    xdg-data-dirs = with pkgs.gnome3;
      concatMapStringsSep ":" schema-path [
        gsettings_desktop_schemas gnome_shell gnome-shell-extensions user-theme
      ];

    shell-ext = "[" +
      (concatMapStringsSep ", " (uuid : "'${uuid}'") cfg.shell.extensions) + "]";

    script = pkgs.writeScriptBin cfg.cmd-name ''
      #!${bash}

      export XDG_DATA_DIRS="${xdg-data-dirs}"

      # Look & Feel
      ${set} org.gnome.desktop.background picture-uri '${cfg.wallpaper}'
      ${set} org.gnome.desktop.screensaver picture-uri '${cfg.wallpaper}'
      ${set} org.gnome.desktop.interface font-name '${cfg.fonts.interface}'
      ${set} org.gnome.desktop.interface document-font-name '${cfg.fonts.documents}'
      ${set} org.gnome.desktop.interface monospace-font-name '${cfg.fonts.monospace}'
      ${set} org.gnome.desktop.wm.preferences titlebar-font '${cfg.fonts.window-titles}'
      ${set} org.gnome.desktop.interface gtk-theme '${cfg.appearance.gtk-theme}'
      ${set} org.gnome.desktop.interface icon-theme '${cfg.appearance.icon-theme}'
      ${set} org.gnome.shell.extensions.user-theme name '${cfg.appearance.shell-theme.theme-name}'

      # Touchpad
      ${set} org.gnome.desktop.peripherals.touchpad tap-to-click ${toBool cfg.touchpad.tap-to-click}
      ${set} org.gnome.desktop.peripherals.touchpad natural-scroll ${toBool cfg.touchpad.natural-scrolling}

      # Hard-coded key bindings
      for i in {1..10}
      do
        ${set} org.gnome.desktop.wm.keybindings switch-to-workspace-"$i" "['<Super>$((i % 10))']"
        ${set} org.gnome.desktop.wm.keybindings move-to-workspace-"$i" "['<Super><Shift>$((i % 10))']"
      done
      ${set} org.gnome.desktop.wm.keybindings close "['<Super><Shift>k']"

      # Shell extensions
      ${set} org.gnome.shell enabled-extensions  "${shell-ext}"
  '';
  in (mkIf cfg.enable
  {
    environment.systemPackages = with pkgs; with gnome3; [
      glib glib.dev
      gsettings_desktop_schemas gnome-shell-extensions
      user-theme flat-remix shelltile dyntopbar
      script
    ];
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
# 2. System Path. Ideally we shouldn't have to hard code it, i.e. this would
# be better:
#
#     "${config.system.path}/share/gsettings-schemas/"
#
# but for some reason it causes infinite recursion!
#
# 3. GSettings Schemas. Looks like NixOS sym-links them under
#
#     /run/current-system/sw/share/gsettings-schemas
#
# e.g. you'll find `gsettings-desktop-schemas-3.20.0` in there among others.
# Each of these dirs should be added to $XDG_DATA_DIRS for `gsettings` to
# be able to find the corresponding schema though. In fact,
#  "At runtime, GSettings looks for schemas in the glib-2.0/schemas
#   subdirectories of all directories specified in the XDG_DATA_DIRS
#   environment variable."
# Straight from the horse's mouth. NixOS GNOME session sets up XDG_DATA_DIRS
# correctly with all those dirs (see gnome3.nix), but here we have to do it
# ourselves cos the script may run outside of a GNOME session---e.g. called
# by another module to do user configuration.
#
# 4. gnome-shell-extensions
        # TODO not the right one for
        # org.gnome.shell.extensions.user-theme
        # probably comes with user theme ext
        # which I'll have to pkg myself...

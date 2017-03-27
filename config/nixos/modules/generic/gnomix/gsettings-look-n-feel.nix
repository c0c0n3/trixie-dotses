#
# GNOME 3 appearance settings.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ../../../pkgs;
with import ./gsettings-utils.nix;
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
    ext.gsettings.wallpaper = mkOption {
      type = nullOr path;
      default = null;
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
      default = flat-remix-gnome-theme;
      description = ''
        GNOME Shell theme.
      '';
    };
    ext.gsettings.shell.extensions = mkOption {
      type = listOf string;
      default = [
        user-theme.uuid shelltile.uuid dynamictopbar.uuid
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

    script = ''
      # Look & Feel
      ${set} org.gnome.desktop.background picture-uri '${toString cfg.wallpaper}'
      ${set} org.gnome.desktop.screensaver picture-uri '${toString cfg.wallpaper}'
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
    '';
  in (mkIf cfg.enable
  {
    environment.systemPackages = with pkgs; with gnome3; [
      glib glib.dev
      gsettings_desktop_schemas gnome-shell-extensions
      flat-remix-gnome-theme
    ];

        # Add a fragment to the gsettings script to enable the extensions.
    # Also add the schema gsettings is going to need to set the value.
    ext.gnomix.gsettings.script.lines.tmp = script;
    ext.gnomix.gsettings.script.xdg-data-dirs = with pkgs.gnome3; [
      gsettings_desktop_schemas gnome_shell gnome-shell-extensions user-theme
    ];

    ext.gnomix.shell.extensions.enable = true;
    ext.gnomix.shell.extensions.packages = [
      user-theme shelltile dynamictopbar
    ];

    ext.gnomix.gsettings.script.enable = true;
  });

}

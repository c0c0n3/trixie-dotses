#
# Enable this module to pre-configure GNOME with our fonts, key-bindings,
# theme, etc. See code below.
# This module also installs the Numix theme and icons as well as the Ubuntu
# font family that we use as a default font in our settings.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    ext.gnomix.config.defaults.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        You want our default settings?
      '';
    };
  };

  config = let
    enabled = config.ext.gnomix.config.defaults.enable;
    emacs = "emacs";
    etermd-client = config.ext.etermd.client-cmd-name;
  in (mkIf enabled
  {
    # Our settings.
    ext.gnomix = {  # NOTE (1)
      gsettings = {
        fonts = {
          window-titles = "Ubuntu Medium 11";
          interface = "Ubuntu Regular 13";
          documents = "Ubuntu Regular 13";
          monospace = "Ubuntu Mono Regular 15";
        };

        gtk-theme = "Numix";
        gtk-theme-prefer-dark = true;
        icon-theme = "Numix-Circle";
        clock-show-date = true;

        keys = {
          switch-to-workspace-down = [ "<Super>Down" ];
          switch-to-workspace-up = [ "<Super>Up" ];
          switch-to-workspace = "<Super>";
          move-to-workspace = "<Super><Shift>";
          maximize = [];
          unmaximize = [];
          minimize = [];
          close = [ "<Super><Shift>k" ];
          custom = [{ name    = "Emacs";
                      command = emacs;
                      binding = "<Super><Shift>e";
                    }
                    { name    = "ETerm";
                      command = etermd-client;
                      binding = "<Super><Shift>Return";
                    }];
        };

        touchpad = {
          tap-to-click = true;
          natural-scrolling = true;
        };
      };

      shell.extensions = {
        enable = true;
        packages = with config.ext.pkgs; [ shelltile dynamictopbar ];
        uuids = [
          "launch-new-instance@gnome-shell-extensions.gcampax.github.com" ];
        user-theme = {
          enable = true;
          package = config.ext.pkgs.flat-remix-gnome-theme;
        };
      };
    };

    # Install additional packages we need for our settings.
    # NB some of the modules above already install their deps.
    environment.systemPackages = with pkgs; with gnome3; [
      gnome-shell-extensions  # installs launch-new-instance extension
    ] ++ config.ext.numix.packages;

    # Install fonts used in our settings.
    fonts.fonts = with pkgs; [
      ubuntu_font_family       # used in gsettings.fonts.*
    ];
  });

}
# Notes
# -----
# 1. GSettings script. If `gnomix.config.enable == false` then the settings
# script doesn't get generated which means the shell extensions won't be
# enabled.

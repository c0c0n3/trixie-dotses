#
# A lightweight desktop with X and a window manager of your choice.
# Supports automatic login of a chosen user.
#
{ config, pkgs, lib, ... }:

with lib;
{

  options = {
    ext.wmx.enable = mkOption {
      type = types.bool;
      default = false;
      description = ''
        If enabled, you'll get a lightweight desktop with X running a WM of
        your choice. Additionally you can have automatic login for a user.
      '';
    };
    ext.wmx.wmName = mkOption {
      type = types.string;
      default = "i3";
      description = ''
        What WM to use.
      '';
    };
    ext.wmx.autoLoginUser = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = ''
        If specified, this user gets automatically logged in.
      '';
    };
    ext.vmx.dmName = mkOption {
      type = types.string;
      default = "slim";
      description = ''
        What display manager to use, e.g. "gdm".
      '';
    };
  };

  config = let
    enabled = config.ext.wmx.enable;
    wm = config.ext.wmx.wmName;
    user = config.ext.wmx.autoLoginUser;
    dm = config.ext.vmx.dmName;
  in
  {
    services.xserver = mkIf enabled ({
      enable = true;

      # Enable the selected DM. If we have an autoLoginUser, log her in
      # without a password, hiding the display manager login prompt.
      displayManager."${dm}" = {
        enable = true;
        autoLogin = if dm == "slim" then !(isNull user)        # NOTE (1)
                    else {
                      enable = !(isNull user);
                      user = user.name;
                    };
      } // (if (dm == "slim") then { defaultUser = user.name; } else {});


    } // (if wm == null then {} else {
      # Enable the requested WM.
      windowManager."${wm}".enable = true;

      # You'll need both the following lines for auto login to work properly
      # with a standalone window manager, i.e. without a desktop manager such
      # as GNOME.
      # Without either line, you'll end up with an xterm on screen and no
      # window manager.
      windowManager.default = wm;
      desktopManager.xterm.enable = false;
    }));
  };

}
# Notes
# -----
# 1. Auto-login Hack. NixOS DM modules have an `autoLogin` set with `enable`
# and `user` props. Except for Slim where `autoLogin` is a boolean and you
# specify the user with `defaultUser`. (Ouch!)

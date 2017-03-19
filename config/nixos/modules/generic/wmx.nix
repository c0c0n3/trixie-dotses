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
    services.xserver = mkIf enabled {
      enable = true;
      windowManager."${wm}".enable = true;

      # Enable the selected DM. If we have an autoLoginUser, log her in
      # without a password, hiding the display manager login prompt.
      /*
      displayManager."${dm}" = {
        enable = true;
        autoLogin = {
         enable = dm != "slim" && !(isNull user);
         user = user.name;
        };
      };
      displayManager.auto = {
        enable = dm == "slim" && !(isNull user);
        user = user.name;
      };
*/
      displayManager."${dm}" = {
        enable = true;
        autoLogin = if dm == "slim" then !(isNull user)
                    else {
                      enable = !(isNull user);
                      user = user.name;
                    };
      } // (if (dm == "slim") then { defaultUser = user.name; } else {});

      # You'll need both the following lines for auto login to work properly.
      # Without either of them, you'll end up with an xterm on screen and no
      # window manager.
      windowManager.default = wm;
      desktopManager.xterm.enable = false;
    };
  };

}

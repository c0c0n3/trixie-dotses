#
# GNOME configuration.
# This module enables the generation of a GNOME configuration script to store
# the various `gnomix*` config items in a user's GSettings database---look at
# `gsettings/script` for the details. We'll put the script in the system PATH
# so each user can run it.
#
# Additionally, if you specify a set of users to this module, we'll run the
# script at system activation time. There's one limitation though with this
# automated running of the script: it'll only work if you activate the new
# system config (i.e. `nixos-rebuild`) within a running GNOME session.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ./gsettings/utils.nix;
{

  options = {
    ext.gnomix.config.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables the generation of a GNOME configuration script that any user
        can run to store our `gnomix` settings into their GSettings database.
      '';
    };
    ext.gnomix.config.users = mkOption {
      type = listOf attrs;
      default = [];
      description = ''
        List of users who want to `gnomix` config items reflected in their
        GNOME config database on system activation. If empty, nothing happens.
      '';
    };
  };

/* TODO this is not working!
I get these messages when running the script at sys activation time:

  GLib-GIO-Message: Using the 'memory' GSettings backend.
  Your settings will not be saved or shared with other applications.

Even though I've added dconf to the PATH (see below), there's still
something missing. My guess is that it could be some .so, i.e. I might
have to set LD_LIBRARY_PATH as done in the NixOS gnome3.nix module where
they ready the GNOME session's env.

  config = let
    cfg = config.ext.gnomix.config;

    path = concatStringsSep ":" [
      "${pkgs.utillinux}/bin/"
      "${pkgs.gnome3.dconf}/bin"
      "${config.ext.gnomix.gsettings.script.package}/bin"
    ];

    cmd = config.ext.gnomix.gsettings.script.cmd-name;
    buildCmd = usr: "runuser ${usr.name} -c ${cmd}";

    script = unlines (
      [ "export PATH=$PATH:${path}" ] ++
      (map buildCmd cfg.users));
  in (mkIf cfg.enable
  {
    system.activationScripts.gnomix-config =
      stringAfter [ "users" "usrbinenv" ] script;
      # NB does nothing if users == [].
  });
*/
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
# Note that `dconf` lets you write the settings too but doesn't do any
# schema validation which is why I'm using `gsettings` instead.

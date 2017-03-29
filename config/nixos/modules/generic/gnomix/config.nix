#
# TODO
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ../../../pkgs;
{

  options = {
    ext.gnomix.config.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        TODO
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.config;
  in (mkIf cfg.enable
  {

    # TODO move outta here!
    ext.gnomix.config.defaults.enable = true;
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
# Note that `dconf` lets you write the settings too but doesn't do any
# schema validation which is why I'm using `gsettings` instead.

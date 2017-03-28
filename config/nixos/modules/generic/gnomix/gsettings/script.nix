#
# Script to load GSettings specified by gnomix modules into the GNOME config
# DB.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    ext.gnomix.gsettings.script.cmd-name = mkOption {
      type = string;
      default = "gnomix-settings.load";
      description = ''
        The name of the script to load the settings.
      '';
    };
    ext.gnomix.gsettings.script.lines = mkOption {
      type = attrsOf string;
      default = {};
      description = ''
        The lines that make up the script. Each module adds its specific bits.
      '';
    };
    ext.gnomix.gsettings.script.xdg-data-dirs = mkOption {
      type = listOf package;
      default = [];
      description = ''
        The packages containing the GSettings schemas that have to be available
        to the gsettings for it to be able to set values in the config DB.
        Each module adds packages depending on what settings they use in the
        lines option.
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.gsettings.script;
    enabled = config.ext.gnomix.gsettings.enable &&
              length (attrNames cfg.lines) > 0;

    bash = "${pkgs.bashInteractive}/bin/bash";

    schema-path = pkg : "/run/current-system/sw/share/gsettings-schemas/" +
                        "${pkg.name}";  # NOTE (1) (2)
    xdg-data-dirs = concatMapStringsSep ":" schema-path
                      (unique cfg.xdg-data-dirs);

    script = pkgs.writeScriptBin cfg.cmd-name ''
      #!${bash}

      export XDG_DATA_DIRS="${xdg-data-dirs}"

      ${concatStringsSep "\n" (attrValues cfg.lines)}
    '';
  in (mkIf enabled {
    environment.systemPackages = [ script ];
  });

}
# Notes
# -----
# 1. System Path. Ideally we shouldn't have to hard code it, i.e. this would
# be better:
#
#     "${config.system.path}/share/gsettings-schemas/"
#
# but for some reason it causes infinite recursion!
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
# Straight from the horse's mouth. NixOS GNOME session sets up XDG_DATA_DIRS
# correctly with all those dirs (see gnome3.nix), but here we have to do it
# ourselves cos the script may run outside of a GNOME session---e.g. called
# by another module to do user configuration.

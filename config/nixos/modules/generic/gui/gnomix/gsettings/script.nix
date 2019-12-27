#
# Script to load GSettings specified by gnomix modules into the GNOME config
# DB. The script will be in your PATH so you can run it to load the settings.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ./utils.nix;
{

  options = {
    ext.gnomix.gsettings.script.cmd-name = mkOption {
      type = str;
      default = "gnomix-settings.load";
      description = ''
        The name of the script to load the settings.
      '';
    };
    ext.gnomix.gsettings.script.package = mkOption {
      type = nullOr package;
      default = null;
      description = ''
        The package of the script to load the settings. We'll populate it
        automatically on enabling this module.
      '';
    };
    ext.gnomix.gsettings.script.lines = mkOption {
      type = attrsOf str;
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
        to gsettings for it to be able to set values in the config DB.
        Each of our gsettings modules must add packages here depending on what
        settings it uses in the lines option. We install each package you list
        here.
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.gsettings.script;
    enabled = config.ext.gnomix.config.enable;  # NOTE (1)

    bash = "${pkgs.bashInteractive}/bin/bash";

    schema-path = pkg : "/run/current-system/sw/share/gsettings-schemas/" +
                        "${pkg.name}";  # NOTE (2) (3)
    xdg-data-dirs = concatMapStringsSep ":" schema-path
                      (unique cfg.xdg-data-dirs);

    script = pkgs.writeScriptBin cfg.cmd-name ''
      #!${bash}

      export XDG_DATA_DIRS="${xdg-data-dirs}"

      ${unlines (attrValues cfg.lines)}
    '';
  in (mkIf enabled
  {
    # Install the script as well as all the packages containing the referenced
    # schemas.
    environment.systemPackages = [ script ] ++ cfg.xdg-data-dirs;

    # Populate the script package reference so it can be used by other modules
    # to call the script.
    ext.gnomix.gsettings.script.package = script;
  });

}
# Notes
# -----
# 1. Script Generation. If no module adds lines, we gonna end up with a script
# with no statements past the `export`. So it'll do nothing when you run it.
# But we still keep to avoid runtime errors if other modules call it.
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

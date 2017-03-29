#
# Installs and enables GNOME Shell extensions.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ../gsettings/utils.nix;
{

  imports = [
    ./user-theme.nix
  ];

  options = {
    ext.gnomix.shell.extensions.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install the listed GNOME Shell extensions.
      '';
    };
    ext.gnomix.shell.extensions.packages = mkOption {
      type = listOf package;
      default = [];
      description = ''
        GNOME Shell extension packages. They're expected to have a `uuid`
        attribute set to the UUID value as found in the extension's
        metadata. Also we expect the package links up the extension schema
        correctly as done in the NixOS shell extension packages or in our
        extension packages---see `pkgs/gnome-shell-exts`.
        We install each package and enable it in the GNOME Shell.
      '';
    };
    ext.gnomix.shell.extensions.uuids = mkOption {
      type = listOf string;
      default = [];
      description = ''
        GNOME Shell extension UUID's. These are UUID's of extensions you've
        installed without using any of the packages listed in
          ext.gnomix.shell.extensions.packages
        We enable the extensions corresponding to the listed UUID's in the GNOME
        Shell but we don't check each extension is actually installed correctly.
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.shell.extensions;
    enabled = cfg.enable;

    uuids = cfg.uuids ++ (map (p : p.uuid) cfg.packages);
    script = setIfFragment "Shell extensions" {
      "org.gnome.shell enabled-extensions" = uuids;
    };
  in (mkIf enabled {  # NOTE (1)
    # Install each extension provided as a Nix package and tell the NixOS
    # GNOME module to make the corresponding schemas available through
    # $XDG_DATA_DIRS. (We assume the package has symlinked the schema dirs
    # as expected by `gnome3.nix`.)
    environment.systemPackages = cfg.packages;
    services.xserver.desktopManager.gnome3.sessionPath = cfg.packages;

    # Add a fragment to the gsettings script to enable the extensions and
    # specify the schema gsettings is going to need to set the value.
    ext.gnomix.gsettings.script.lines.shell-extensions = script;
    ext.gnomix.gsettings.script.xdg-data-dirs = [ pkgs.gnome3.gnome_shell ];
  });

}
# Notes
# -----
# 1. GSettings script. If `gnomix.config.enable == false` then the settings
# script doesn't get generated which means the shell extensions won't be
# enabled.

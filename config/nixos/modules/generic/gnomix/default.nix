#
# A GNOME 3 desktop on NixOS.
# The GUI stack is made up by X, GDM, GNOME 3, and the latest Emacs that we
# use both as the system-wide editor and terminal.
# This module just pulls together other modules to install:
#
# * X, GDM, and GNOME 3 (built-in NixOS modules)
# * Latest Emacs (`base.nix`)
# * Emacs terminal daemon (`base.nix`)
# * Bash completion and a bunch of useful CLI tools (`base.nix`)
# * Aspell with the English dictionary (`base.nix`)
#
# and then makes:
#
# * Emacs the default editor system-wide (`EDITOR` environment variable)
#
# The Emacs terminal daemon is available from the CLI, you may want to bind
# the command to a key combination---as in i3.
#
# This is a full-blown, fat desktop. If you'd rather want a lightweight one,
# look at the `i3e-base` module.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  imports = [
    ./gsettings
    ./shell-extensions
    ./config-defaults.nix
    ./config.nix
  ];

  options = {
    ext.gnomix.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install this desktop environment.
      '';
    };
    ext.gnomix.autoLoginUser = mkOption {
      type = nullOr attrs;
      default = null;
      description = ''
        If specified, this user gets automatically logged in.
      '';
    };
  };

  config = let
    enabled = config.ext.gnomix.enable;
    user = config.ext.gnomix.autoLoginUser;
  in (mkIf enabled {
    # Install our core system base.
    ext.base.enable = true;

    # Install and set up GNOME 3.
    services.xserver = {
       enable = true;
       displayManager.gdm = {
        enable = true;
        autoLogin = {
          enable = !(isNull user);
          user = user.name;
        };
      };
      desktopManager.gnome3.enable = true;
    };

  });

}
# Notes
# -----
# 1. Excluding GNOME Packages. Can be done if you really need to? Use:
#
#      environment.gnome3.excludePackages = [ ... ];
#

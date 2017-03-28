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
# the command to a key combination---as in i3. This module also installs the
# Numix theme and icons as well as some extra fonts: Alegreya, Ubuntu, and
# Source Code Pro. To use any of these goodies you'll have to set them in
# the GNOME prefs yourself.

# This is a full-blown, fat desktop. If you'd rather want a lightweight one,
# look at the `i3e-base` module.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ../../../pkgs;
{

  imports = [
    ./gsettings
    ./shell-extensions
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

    # Add some more software on top of what GNOME core already provides.
    environment.systemPackages = with pkgs;
      config.ext.numix.packages ++ [
      user-theme flat-remix-gnome-theme shelltile dynamictopbar
    ];
    services.xserver.desktopManager.gnome3.sessionPath = [
      shelltile dynamictopbar
    ];
    fonts.fonts = with pkgs; [
      ubuntu_font_family
      source-code-pro
      alegreya alegreya-sans
    ];

    # TODO how to specify GNOME settings programmatically?
    # It can be done using dconf + gsettings, see e.g.
    #   https://github.com/pixelastic/dconf-export
    # but how to do it in NixOS?!
    # Things I'd like to set:
    # - key bindings similar to i3, terminal daemon in particular
    # - numix theme & icons
    # - prefer dark theme
    # - default fonts
    # - wallpaper
    # - gnome-terminal w/o menu + font spec
    # - GNOME shell
    #   * extensions: User Themes, Shelltile, Dynamic Top Bar
    #   * theme: Flat Remix
    # - what else?
  });

}
# Notes
# -----
# 1. Excluding GNOME Packages. Can be done if you really need to? Use:
#
#      environment.gnome3.excludePackages = [ ... ];
#

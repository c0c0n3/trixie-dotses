#
# Integrates GNOME 3 with the bare-bones desktop provided by i3e-base.
#
{ config, lib, pkgs, ... }:

with lib;
with types;

{

  options = {
    ext.i3g.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install this desktop environment.
      '';
    };
  };

  config = let
    enabled = config.ext.i3g.enable;
  in (mkIf enabled {

    # Start off with a bare-bones desktop.
    ext.i3e-base.enable = true;

    # Integrate our bare-bones desktop into GNOME 3.
    services.xserver.desktopManager.gnome3.enable = true;
    ext.vmx.dmName = "gdm";  # i3 session won't work with slim.

    # Add some more software on top of what GNOME core already provides
    # but get rid of most of GNOME's non-core packages.
    environment.systemPackages = with pkgs;
      config.ext.numix.packages ++
      [ # TODO
      ];
    environment.gnome3.excludePackages = [
      # TODO
    ];
    fonts.fonts = [
      # TODO
    ];

    # TODO how to specify GNOME settings programmatically? e.g. dconf
    # - numix theme & icons
    # - prefer dark theme
    # - default fonts
    # - compositor
    # - gnome-terminal w/o menu + font spec
    # - what else?
  });

}
# Notes
# -----
# 1. GNOME Shell. Can't start it. Might not be included in the .desktop file
# that starts the GNOME session.
# 2. GNOME + i3. This is how to do it on Arch
# - https://github.com/TheMarex/i3-gnome
# Could be useful going forward if I need to replace the default .desktop
# file NixOS uses to start the GNOME session with i3 as window manager.

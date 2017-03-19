#
# Configures the Numix theme and circle icons for the specified users.
# NB Do *not* use this with GNOME, rather set the theme through desktop
# tools.
#
{ config, pkgs, lib, ... }:

with lib;
with types;

{

  options = {
    ext.numix.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Use the Numix GTK 3 theme and icons.
      '';
    };
    ext.numix.packages = mkOption {
      type = listOf package;
      default = with pkgs; [
        numix-gtk-theme numix-icon-theme numix-icon-theme-circle
      ];  # NOTE (1) (2)
      description = ''
        The Numix GTK 3 theme and icons packages.
      '';
    };
  };

  config = let
    enabled = config.ext.numix.enable;
  in (mkIf enabled {

    ext.gtk3.theme.name = "Numix";
    ext.gtk3.theme.icons-name = "Numix-Circle";

    environment.systemPackages = config.ext.numix.packages;

  });

}
# Notes
# -----
# 1. Numix Icons. The base icon set is in numix-icon-theme, the circle theme
# just adds the app icons and symlinks all the others back to the base theme.
# So you need to install both icon themes.
# 2. Numix Light. The Numix packages also contain the light variant for both
# the theme (Numix-Light) and the icons (Numix-Circle-Light).
#

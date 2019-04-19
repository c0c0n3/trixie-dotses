#
# Configures GTK 3 settings for the specified users.
# NB Do *not* use this with GNOME, rather specify settings through desktop
# tools.
#
{ config, pkgs, lib, ... }:

with builtins;
with lib;
with types;

let
  dot-link = import ../dot-link-utils.nix;
  boolToString = b: if b then "true" else "false";
in {

  options = {
    ext.gtk3.users = mkOption {
      type = listOf attrs;
      default = [];
      description = ''
        List of users who want to use the GTK 3 theme. If empty, nothing happens.
      '';
    };
    ext.gtk3.theme.name = mkOption {
      type = string;
      default = "Adwaita";
      description = ''
        The name of the GTK 3 theme to use. Defaults to Adwaita.
      '';
    };
    ext.gtk3.theme.icons-name = mkOption {
      type = string;
      default = "Adwaita";
      description = ''
        The name of the GTK 3 icon theme to use. Defaults to Adwaita.
      '';
    };
    ext.gtk3.theme.dark = mkOption {
      type = bool;
      default = true;
      description = ''
        Should GTK 3 use the theme's dark variant? Defaults to true.
      '';
    };
    ext.gtk3.font = mkOption {
      type = string;
      default = "DejaVu Sans 11";
      description = ''
        The GTK 3 app font to use. Defaults to "DejaVu Sans 11".
      '';
    };
  };

  config = let
    cfg = config.ext.gtk3;
    enabled = length cfg.users != 0;
    settings = toFile "settings.ini" ''
      [Settings]
      gtk-theme-name = ${cfg.theme.name}
      gtk-icon-theme-name = ${cfg.theme.icons-name}
      gtk-application-prefer-dark-theme = ${boolToString cfg.theme.dark}
      gtk-font-name = ${cfg.font}
    '';
  in (mkIf enabled {

    # Sym-link GTK 3 config into homes.
    ext.dot-link.files = dot-link.mkLinks cfg.users [{
        src = settings;
        dst = ".config/gtk-3.0/settings.ini";  # NOTE (1)
        skipCheck = true;
    }];

    environment.systemPackages = with pkgs; [
      # Avoid missing icons issues. NOTE (3)
      hicolor_icon_theme gnome3.adwaita-icon-theme

      # Install fonts we used as a default option.
      dejavu_fonts
    ];

  });

}
# Notes
# -----
# 1. Config Lookup. According to the XDG base dir spec, an app should first
# look for config files in $XDG_CONFIG_HOME defaulting to $HOME/.config if
# $XDG_CONFIG_HOME is not set or empty. Then the app should look in the dirs
# listed by $XDG_CONFIG_DIRS. Without a desktop environment (Gnome, etc.)
# my env doesn't have $XDG_CONFIG_HOME set so apps should look into ~/.config
# which is where I'm sym-linking settings.ini. This works for most apps but
# not for all. For example PCManFS won't pick up the GTK 3 theme even if you
# add $HOME/.config to $XDG_CONFIG_DIRS or set $GTK_DATA_PREFIX to
# "${config.system.path}".
#
# 2. Themes Location. NixOS already adds /run/current-system/sw/share
# to $XDG_DATA_DIRS (see nixos/modules/programs/environment.nix) so
# themes and icons work cos GTK 3 uses this variable to find themes and
# icons, see
# - https://developer.gnome.org/gtk3/stable/gtk-running.html
#
# 3. Icons. Adwaita is the default GTK 3 theme but you have to explicitly
# install its icon theme otherwise some GTK apps may not be able find icons
# even after installing the hicolor icon theme---default fallback theme as
# per free desktop's icon theme spec.
#
# 4. Environment. We leave the task of setting env vars out of this module.
# In fact, this is the job of a desktop environment module, see e.g. what
# gnome.nix does and refer to the link above about running GTK apps. Even
# without those additional settings, themes should pretty much work for
# most apps anyway.

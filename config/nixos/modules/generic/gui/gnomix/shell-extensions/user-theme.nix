#
# Installs, enables, and configures the User Themes GNOME Shell extension.
# Any config option below can be null in which case it's ignored. If you want
# to clear the corresponding setting in the GNOME config DB, set the option to
# an empty string or list as the case may be.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
with import ../gsettings/utils.nix;
{

  options = {
    ext.gnomix.shell.extensions.user-theme.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Should we install and enable the User Themes extension?
      '';
    };
    ext.gnomix.shell.extensions.user-theme.package = mkOption {
      type = nullOr package;
      default = null;
      description = ''
        The Nix package of the theme you want the GNOME Shell to use.
        We'll install the specified package and make the GNOME Shell
        use this theme.
        We expect the package to have a `theme-name` attribute set to
        the name the GNOME Shell should use to locate the theme---see
        e.g. our `flat-remix-gnome-theme.nix`.
      '';
    };
    ext.gnomix.shell.extensions.user-theme.name = mkOption {
      type = nullOr string;
      default = null;
      description = ''
        The name of the theme you want the GNOME Shell to use. We'll only
        use this option if the `package` option is `null`. Obviously for
        this to work you'll have to have installed the theme yourself.
      '';
    };
  };

  config = let
    cfg = config.ext.gnomix.shell.extensions.user-theme;
    enabled = cfg.enable;

    theme-name = if cfg.package == null then cfg.name
                 else cfg.package.theme-name;
    script = setIfFragment "GNOME Shell theme" {
      "org.gnome.shell.extensions.user-theme name" = theme-name;
    };

    user-theme = config.ext.pkgs.user-theme;
  in (mkIf enabled
  {
    # Install and enable the extension in the GNOME Shell.
    ext.gnomix.shell.extensions.packages = [ user-theme ];  # NOTE (1)

    # Add a fragment to the gsettings script to configure the extension and
    # specify the schema gsettings is going to need to set config values.
    ext.gnomix.gsettings.script = {
      lines.shell-extensions-user-theme = script;
      xdg-data-dirs = [ user-theme ];
    };

    # If we have a Nix theme package, install it.
    environment.systemPackages = mkIf (cfg.package != null) [ cfg.package ];
  });

}
# Notes
# 1. Shell extensions module. It's got to be enabled for this module to
# actually to anything.

#
# Single-user GNOME desktop.
# This module basically just adds a user on top of what gnomix and base-config
# already provide. In fact, we create the admin user with initial password of
# `abc123`, build a GNOME desktop for him and log him in automatically, hiding
# the display manager. Then we make him use our Spacemacs and Bash config.
# This kind of set up is obviously only useful for single-user workstations.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
let
  paths = import ./paths.nix;
in
{

  options = {
    ext.yougnomix.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to get a single-user GNOME desktop.
      '';
    };
    ext.yougnomix.username = mkOption {
      type = string;
      default = null;
      description = ''
        The desktop owner's user name.
      '';
    };
  };

  config = let
    owner-name = config.ext.yougnomix.username;
    owner = config.users.users."${owner-name}";
    enabled = if config.ext.yougnomix.enable
              then (assert owner-name != null && owner-name != ""; true)
              else false;
  in (mkIf enabled
  {
    # Create the admin user with initial password of `abc123`.
    ext.users.admins = [ owner-name ];

    # Build a GNOME desktop for him and log him in automatically, hiding the
    # display manager. Also spice up the base GNOME desktop a bit with our
    # default GNOME configuration and wallpaper.
    ext.gnomix = {
      enable = true;
      autoLoginUser = owner;

      config = {
        enable = true;
        defaults.enable = true;
      };
      gsettings.wallpaper = paths.wallpapers
        "/4ever.eu.splash,-atomic-explosion,-water-148870.jpg";
    };

    # Make him use our Spacemacs and Bash config.
    ext.base.config.users = [ owner ];
  });

}

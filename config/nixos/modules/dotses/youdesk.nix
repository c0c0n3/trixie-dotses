#
# Single-user bare-bones desktop.
# This module basically just adds a user on top of what baredesk already
# provides. In fact, we create the admin user with initial password of
# `abc123`, build a bare-bones desktop for him and log him in automatically,
# hiding the display manager. This kind of set up is obviously only useful
# for single-user workstations.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    ext.youdesk.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to get a single-user bare-bones desktop.
      '';
    };
    ext.youdesk.username = mkOption {
      type = string;
      default = null;
      description = ''
        The desktop owner's user name.
      '';
    };
  };

  config = let
    owner-name = config.ext.youdesk.username;
    owner = config.users.users."${owner-name}";
    enabled = if config.ext.youdesk.enable
              then (assert owner-name != null && owner-name != ""; true)
              else false;
  in (mkIf enabled
  {
    # Create the admin user with initial password of `abc123`.
    ext.users.admins = [ owner-name ];

    # Build a bare-bones desktop for him.
    ext.baredesk = {
      enable = true;
      users = [ owner ];
    };

    # Log him in automatically, hiding the display manager.
    ext.wmx.autoLoginUser = owner;
  });

}

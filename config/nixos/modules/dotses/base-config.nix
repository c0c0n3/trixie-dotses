#
# User configuration for the programs installed by `base.nix`.
# This module uses our Spacemacs, and Bash dotses modules to configure Emacs
# and Bash for a set of users.
# In particular:
#
# * Emacs becomes Spacemacs;
# * `etermd` uses our Spacemacs terminal config, so when you start a terminal
#   you get our Spacemacs terminal;
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    ext.base.config.users = mkOption {
      type = listOf attrs;
      default = [];
      description = ''
        List of users who want their base system (`base.nix`) configured with
        the dot files in this repo: Spacemacs and Bash. If empty nothing
        happens.
      '';
    };
  };

  config = let
    cfg = config.ext.base.config;
    enabled = length cfg.users != 0;
  in (mkIf enabled
  {
    # Install Spacemacs with our config for all specified users and enable the
    # terminal daemon, making it use our Spacemacs terminal config.
    ext.spacemacs.users = cfg.users;
    ext.spacemacs.config.enable = true;
    ext.spacemacs.config.with-etermd = true;

    # Install our Bash config for all specified users.
    ext.bash.config.users = cfg.users;
  });

}

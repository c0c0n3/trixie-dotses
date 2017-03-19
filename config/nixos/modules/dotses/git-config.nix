#
# Install our git config for a specific user.
# NOTE
# Not doing this for multiple users at the moment cos `config/git/.gitconfig`
# has a user name and email in it. Going forward, I should consider writing
# `.gitconfig` directly from this module that would then have options to
# specify a git user name and email for each user who wants to install the
# git config.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
let
  paths = import ./paths.nix;
  dot-link = import ../generic/dot-link-utils.nix;
in {

  options = {
    ext.git.config.user = mkOption {
      type = nullOr attrs;
      default = null;
      description = ''
        User for who to install our git config.
      '';
    };
  };

  config = let
    enabled = user != null;
    user = config.ext.git.config.user;
    users = if enabled then [ user ] else [];
    links = [
      { src = paths.config "/git/.gitconfig"; }
      { src = paths.config "/git/.gitignore_global"; }
    ];
  in {
    # Sym-link git config into user's home.
    # NB does nothing if users == [].
    ext.dot-link.files = dot-link.mkLinks users links;
  };

}

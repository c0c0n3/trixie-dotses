#
# Install our Bash config for all users who request it.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
let
  paths = import ./paths.nix;
  dot-link = import ../generic/dot-link-utils.nix;
in {

  options = {
    ext.bash.config.users = mkOption {
      type = listOf attrs;
      default = [ ];
      description = ''
        Users for who to install our Bash config.
      '';
    };
  };

  config = let
    enabled = length users != 0;
    users = config.ext.bash.config.users;
    links = [{ src = paths.config "/bash/.bashrc"; }];
  in {
    # Sym-link Bash config into homes.
    # NB does nothing if users == [].
    ext.dot-link.files = dot-link.mkLinks users links;
  };

}

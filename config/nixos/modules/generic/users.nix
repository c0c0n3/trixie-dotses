#
# Creates admin users given their usernames.
# Each admin user is a member of wheel and has an initial password of
# 'abc123'. Also, we assign to each of them explicit consecutive uids,
# starting from 1000 (=uid of the first user in the list).
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    ext.users.admins = mkOption {
      type = listOf string;
      default = [];
      description = ''
        List of usernames for which to create admin users.
      '';
    };
  };

  config = let
    admins = config.ext.users.admins;
    pwd = "$6$DmW6Owb/Swuzs7$DKca.vHGUP3bTz/G5vae4/egALZVVdsGdkhzISU11ZsFy2jmMVkZtIwTbNzK5cau9AOmb2B4LTd6BxcOKR1oW1";

    mkusr = username: ix: {
          name = username;
          value = {
              isNormalUser = true;
              uid = 1000 + ix;
              extraGroups = [ "wheel" ];
              hashedPassword = pwd;
          };
    };
    adminsAttrs = zipListsWith mkusr admins (range 0 (length admins));
  in
  {
    users.users = listToAttrs adminsAttrs;  # does nothing if admins is empty.
  };

}

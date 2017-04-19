#
# Creates admin users given their usernames.
# For each username, this module creates a corresponding user having that
# username and makes it a member of both `users` and `wheel`. The user is
# also given an initial password of `abc123` and an explicit `uid`.
# We assign these `uid`s consecutively, starting from 1000 (=`uid` of the
# first user in the list).
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
    ext.users.admins-generated = mkOption {
      type = attrs;
      default = {};
      description = ''
        The attributes of each user set we generate. This module will populate
        this set for you with an attributes named after the specified usernames.
        For each of these, the corresponding value is the set of attributes we
        generated for that user: uid, group, home, etc.
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
              group = "users";
              extraGroups = [ "wheel" ];
              hashedPassword = pwd;
              home = "/home/${username}";
          };
    };
    adminsAttrs = zipListsWith mkusr admins (range 0 (length admins));
    adminUsers = listToAttrs adminsAttrs;  # does nothing if admins is empty.
  in
  {
    users.users = adminUsers;
    ext.users.admins-generated = adminUsers;
  };

}

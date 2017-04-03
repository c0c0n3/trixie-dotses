#
# Mounts VirtualBox shared folders under a given user's home, making him own
# the shares and a member of the VirtualBox `vboxsf` group.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    ext.vbox-shares.names = mkOption {
      type = listOf string;
      default = [];
      description = ''
        Names of VirtualBox folders to mount.
      '';
    };
    ext.vbox-shares.username = mkOption {
      type = nullOr string;
      default = null;
      description = ''
        The owner of the mount points (and of all the files in them).
        We also set the group to the owner's primary and make him a
        member of the "vboxsf" group.
      '';
    };
  };

  # ------------- Implementation -------------------------------------
  # Say the user name is "andrea". Then code below makes a mount point
  # named "/home/andrea/d" for each d in dirNames:
  #
  #   fileSystems."/home/andrea/d" = {
  #       fsType = "vboxsf";
  #       device = "d";
  #       options = [ "rw" "uid=1000" "gid=100" "umask=0022" ];
  #   };
  #
  # We figure out the actual uid and gid (see below) but, for the moment,
  # hard code the umask to what should be the default anyway.
  config = let
    enabled = length dirNames != 0 && username != null;
    dirNames = config.ext.vbox-shares.names;
    username = config.ext.vbox-shares.username;

    # Helper function to make a mount point attribute out of a dir name.
    #
    usr = config.users.users."${username}";
    mnt = "/home/${username}"; # "${usr.home}";  TODO (1)
    uid = "1000"; # toString usr.uid;  TODO (1)
    gid =  "100"; # toString config.users.groups."${usr.group}".gid;  TODO (1)
    mount = d: {
      "${mnt}/${d}" = {
        fsType = "vboxsf";
        device = "${d}";
        options = [ "rw" "uid=${uid}" "gid=${gid}" "umask=0022" ];
      };
    };

    mountPoints = foldl (ms: d: ms // (mount d)) {} dirNames;

  in mkIf enabled
  {
    # Set up the mount points.
    fileSystems = mountPoints;

    # Also add the user to VirtualBox's file system group.
    users.users."${username}".extraGroups = [ "vboxsf" ];
  };

}
# Notes
# -----
# 1. Hard-coded User. Temp workaround to NixOS 17.03 recursion woes. If I
# don't hard-code the user's details and get them instead from the usr set,
# Nix bombs out with an infinite recursion error. This is why I've commented
# out the querying of usr. Now hard-coding the values works cos I only ever
# use this module in a VirtualBox VM with a single admin user created with
# my own `users` module---see code there. I've submitted a bug report:
# - https://github.com/NixOS/nixpkgs/issues/24570
# Hope it'll get fixed sometime so I can get rid of the hard-coding.
# NB: this is not a bug I've introduced refactoring the previous version of
# this module that used to work in 16.09. In fact, even if you take this
# module's previous version, you'll see it too is broken in 17.03.

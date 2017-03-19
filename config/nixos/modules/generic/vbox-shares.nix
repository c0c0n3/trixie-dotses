#
# Mounts VirtualBox shared folders under a given user's home, making him own
# the shares.
#
{ config, pkgs, lib, ... }:

with lib;
{

  options = {
    ext.vbox-shares.names = mkOption {
      type = types.listOf types.string;
      default = [];
      description = ''
        Names of VirtualBox folders to mount.
      '';
    };
    ext.vbox-shares.user = mkOption {
      type = types.nullOr types.attrs;
      default = null;
      description = ''
        The owner of the mount points (and of all the files in them).
        We also set the group to the owner's primary.
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
    enabled = builtins.length dirNames != 0 && !(isNull usr);
    dirNames = config.ext.vbox-shares.names;
    usr = config.ext.vbox-shares.user;

    # Helper function to make mount point attribute out of dir name.
    #
    uid = toString usr.uid;
    gid = toString config.users.groups."${usr.group}".gid;
    mount = d: {
          name = "${usr.home}/${d}";
          value = {
                fsType = "vboxsf";
                device = "${d}";
                options = [ "rw" "uid=${uid}" "gid=${gid}" "umask=0022" ];
          };
    };
  in
  {
    fileSystems = mkIf enabled (builtins.listToAttrs (map mount dirNames));
  };

}

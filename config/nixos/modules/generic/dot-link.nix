#
# Linking of dotfiles from this git repo into user's homes.
#
{ config, pkgs, lib, ... }:

with builtins;
with lib;
with types;
let
  paths = (import ./path-utils.nix);
in
{

  options = {
    ext.dot-link.files = mkOption {
      type = listOf attrs;
      default = [];
      description = ''
        List of users that need dotfiles sym-linked in their home.
        Each set in the list looks like this:

            {
              user = ...;
              links = [ { src = ...; dst = ...; } {...} ... ];
            }

        where user is a system user in users.users and links is a list of
        pairs where src is a path to a dotfile and dst is a string with the
        path to the sym-link to create in the user's home to point to src.
        If the dst string is an absolute path, we don't touch it; otherwise
        we resolve it against the user's home. Also, directories in a dst
        path get created as needed.
        One more thing. You can specify a src without a dst. In that case
        the src dotfile name becomes the dst sym-link name too.

        Example. If u is a user (i.e. a suitable set in users.users) and
        u.home = "/home/u", then

            ext.dot-link.files = [{
              user = u;
              links = [
                { src = original/dot/file; dst="dest/.symlink"; }
                { src = original/dot/file; dst="dest/"; }
                { src = original/dot/file; }
              ];
            }];

        results in

            /home/u/dest/.symlink -> /path/to/original/dot/file
            /home/u/dest/file     -> /path/to/original/dot/file
            /home/u/file          -> /path/to/original/dot/file

        (Note: Nix takes care of making your relative src paths absolute.)

        This module always checks that the source path exists and aborts
        compilation if it doesn't. Even though this check is generally useful,
        you'll have to skip it when the source path refers to a file in the
        Nix store created with the builtins.toFile function. In fact in this
        case you'll get a compilation error (string ‘/nix/store/...’ cannot
        refer to other paths) when turning the src path into a string---which
        this module does. To avoid the error, add

            skipCheck = true;

        to your src/dst set.
      '';
    };
  };

  # ------------- Implementation -------------------------------------
  #
  config = let

    srcPath = link:
      if link ? "skipCheck" && link.skipCheck
      then (toString link.src)
      else (assert pathExists link.src; toString link.src);

    dstPath = link: usr: let
      dst = if link ? "dst" then link.dst else "";
    in
      if paths.isAbs dst then dst
      else usr.home + "/" + dst;

    buildCmd = usr: link: let
      s = srcPath link;
      d = dstPath link usr;
      runuser = paths.join pkgs.utillinux "bin/runuser";
    in
    ''
      ${runuser} ${usr.name} -c 'mkdir -p "${dirOf d}"'
      ${runuser} ${usr.name} -c 'ln -sf "${s}" "${d}"'
    '';
    # NOTE (1), (2)

    userCmds = spec: map (buildCmd spec.user) spec.links;

    mergeCmds = foldl' (acc: cmd: acc + "\n" + cmd) "";

    script = mergeCmds (concatMap userCmds config.ext.dot-link.files);

  in
  {
    system.activationScripts.dotfiles =
      stringAfter [ "users" "usrbinenv" ] script;
  };

}
# Notes
# -----
# 1. Ownership. Without runuser, root would own those dirs and symlinks.
# 2. Boot Errors. Looks like NixOS runs the activation scripts at boot time
# too, not only when switching to a new config (nixos-rebuild switch) and
# each and every one of our runuser calls fails with a message of
#
#  stage-2-init: runuser: failed to execute /run/current-system/sw/bin/bash: No such file or directory
#
# (to see those messages: `dmesg | grep runuser`)
# Incidentally, this is a good thing cos ideally I only want the dotfiles
# script to actually do stuff when switching to a new config. So ignore those
# errors until I find a better solution.
# 3. TODO link removal. How do we remove those links when they're no longer
# needed? That is, how do we delete a link that was previously added to
# ext.dot-link.files but is now not in this list anymore? It'll still be
# sitting on the hard drive obviously...

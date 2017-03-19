#
# Installs Spacemacs for a set of users.
# We clone the Spacemacs repo in each user's `~/.emacs.d` as long as this dir
# doesn't exist yet. If a user has an already an existing `~/.emacs.d`, then
# we leave it be, i.e. don't override it with the Spacemacs clone.
# Note that we don't install Emacs.
#
{ config, pkgs, lib, ... }:

with builtins;
with lib;
with types;

let

  runuser = pkgs.utillinux + "/bin/runuser";
  cloneSpacemacsTo = pkgs.git + "/bin/git" +
                     " clone https://github.com/syl20bnr/spacemacs";

  buildCmd = usr: let
    emacsDir = "${usr.home}/.emacs.d";
  in
  ''
    if [ ! -d "${emacsDir}" ]; then
      ${runuser} ${usr.name} -c '${cloneSpacemacsTo} "${emacsDir}"'
    fi
  '';
  # NOTE (1)

  mergeCmds = foldl' (acc: cmd: acc + "\n" + cmd) "";

  spacemacsInstallScript = users: mergeCmds (map buildCmd users);

in {

  options = {
    ext.spacemacs.users = mkOption {
      type = listOf attrs;
      default = [];
      description = ''
        List of users who want Spacemacs installed. If empty, nothing happens.
      '';
    };
  };

  config = let
    enabled = length users != 0;
    users = config.ext.spacemacs.users;
  in {
    system.activationScripts.spacemacs =                       # NOTE (1)
      stringAfter [ "users" "usrbinenv" ] (spacemacsInstallScript users);
      # NB does nothing if users == [].

    environment.systemPackages = mkIf enabled [ pkgs.git ];    # NOTE (2)
  };

}
# Notes
# -----
# 1. Activation Script. NixOS seems to run activation scripts at each boot,
# so we have to make sure we only clone the Spacemacs repo once which is
# why we check if `~/.emacs.d` exists. This is far from optimal, so you may
# want to concoct something better going forward.
# 2. Spacemacs Package. Why not make a Nix Spacemacs package? First off,
# Spacemacs updates itself in `.emacs.d` and then there's a bunch of other
# things you'd have to work out to Nixify Spacemacs, see:
#
# - https://github.com/NixOS/nixpkgs/issues/9068
#
# 3. Spacemacs Package Installation. Spacemacs needs git to clone the melpa
# repo into ~/.emacs.d/.cache/quelpa.
# Without this clone some packages will always be marked as outdated and
# Spacemacs will try to install them hopelessly every time at startup. E.g.
# with my current Spacemacs config, Spacemacs will always try to install
# this package: evil-unimpaired@spacemacs-evil.
# See also:
# - https://github.com/syl20bnr/spacemacs/issues/6610
#

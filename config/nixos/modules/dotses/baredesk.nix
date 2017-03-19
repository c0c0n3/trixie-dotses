#
# Bare-bones desktop.
# A simple GUI running X with i3, spiced up with Spacemacs and useful CLI
# tools. This module enables i3e-base and then configures i3 and Emacs with
# Spacemacs for a set of users: we configure i3 and Spacemacs with the dot
# files in this repo an make i3 use Spacemacs as a terminal too.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
let
  paths = (import ./paths.nix);
in
{

  options = {
    ext.baredesk.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to get a bare-bones desktop running X with i3 and Emacs
        as editor and terminal. In this same goodie bag, you'll also find
        some useful CLI tools.
      '';
    };
    ext.baredesk.users = mkOption {
      type = listOf attrs;
      default = [];
      description = ''
        List of users who want this desktop configured with the dot files in
        this repo: i3, Spacemacs, and Bash.
      '';
    };
  };

  config = let
    enabled = config.ext.baredesk.enable;
    usrs = config.ext.baredesk.users;
    terminal = config.ext.etermd.client-cmd-name;
    etermd = config.ext.etermd.daemon-name;
  in (mkIf enabled
  {
    # Install a system base with i3, Emacs, and useful CLI tools.
    ext.i3e-base.enable = true;

    # i3-desk sets up an Emacs daemon to open terminal buffers. We need this
    # cos we wanna use the Spacemacs config but Spacemacs is a bit slow when
    # starting up. Luckily the daemon makes opening a terminal lightning fast!
    # Here we just make the daemon use our Spacemacs terminal config.
    systemd.user.services."${etermd}".environment = {
      SPACECONF="etermd";
    };

    # Install our i3 config for all specified users, set a default wallpaper,
    # and make i3 launch Spacemacs when hitting the editor key.
    ext.i3.config = {
      users = usrs;
      wallpaper = paths.wallpapers
        "/4ever.eu.splash,-atomic-explosion,-water-148870.jpg";
      editor = "emacs";
    };

    # Install our Spacemacs config for all specified users.
    ext.spacemacs.users = usrs;
    ext.spacemacs.config.enable = true;

    # Install our Bash config for all specified users.
    ext.bash.config.users = usrs;
  });

}

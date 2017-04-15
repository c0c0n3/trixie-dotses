#
# Main module for `madematix` config.
# Defines the host name and brings in all other modules.
#
{ config, lib, pkgs, ... }:

let
  adminName = "andrea";
in
{

  imports = [
    ./modules/dotses
    ./modules/generic
    ./pkgs
    ./boxes/madematix/hidpi.nix
  ];

  ##########  Core System Setup  ###############################################
  networking.hostName = "madematix";
  ext.swapfile.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;
  boot.loader.timeout = 0;
  ext.hidpi.enable = true;

  ##########  Desktop Setup  ###################################################

  ext.yougnomix = {
    enable = true;
    username = adminName;
  };
  ext.gnomix.dmName = "slim";

  ext.vbox-shares = {
    names = [ "dropbox" "github" "playground" "projects" ];
    username = adminName;
  };

  ext.git.config.user = config.users.users.andrea;
  ext.inkscape.config.users = [ config.users.users.andrea ];
  ext.fonts.font-pack.enable = true;
  ext.spacemacs.config.font.size = 36;

}

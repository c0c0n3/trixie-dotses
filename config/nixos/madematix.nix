#
# Main module for `madematix` config.
#
{ config, lib, pkgs, ... }:

{

  imports = [
    ./modules/dotses
    ./modules/generic
    ./hidpi.nix
  ];

  ##########  Core System Setup  ###############################################

  # Set hostname and enable swap.
  networking.hostName = "madematix";
  ext.swapfile.enable = true;

  # VBox setup:
  # - enable virtualbox guest service (even though hardware-configuration.nix
  #   enables it already, we add it here too to make it more visible)
  # - skip fsck on boot cos it won't work with VBox
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;


  ##########  Desktop Setup  ###################################################

  # Create my usual admin user with initial password of `abc123` and build
  # a bare-bones desktop for him, with automatic login.
  ext.youdesk = {
    enable = true;
    username = "andrea";
  };

  # Make my admin user a member of the Vbox group too and set up my usual
  # VBox shares for him.
  users.extraUsers.andrea.extraGroups = [ "vboxsf" ];
  ext.vbox-shares = {
    names = [ "dropbox" "github" "playground" "projects" ];
    user = config.users.extraUsers.andrea;
  };

  # Make my admin use my git config.
  ext.git.config.user = config.users.extraUsers.andrea;

  # Tweak Spacemacs font.
  ext.spacemacs.config.font.size = 36;


  ##########  Desktop Eye Candy  ###############################################

}

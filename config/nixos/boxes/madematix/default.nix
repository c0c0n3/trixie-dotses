#
# Main module for `madematix` config.
#
{ config, lib, pkgs, ... }:

let
  adminName = "andrea";
in
{

  imports = [
    ../../modules/dotses
    ../../modules/generic
    ../../pkgs
    ./hidpi.nix
  ];

  ##########  Core System Setup  ###############################################

  # Set hostname and enable swap.
  networking.hostName = "madematix";
  ext.swapfile.enable = true;

  # Hide boot loader menu. The loader will boot the latest NixOS generation.
  # NB you won't be able to rollback to an earlier NixOS generation at boot.
  boot.loader.timeout = 0;

  # VBox setup:
  # - enable virtualbox guest service (even though hardware-configuration.nix
  #   enables it already, we add it here too to make it more visible)
  # - skip fsck on boot cos it won't work with VBox
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;

  # Tweak resolution to take advantage of the retina display on my mactop.
  ext.hidpi.enable = true;

  ##########  Desktop Setup  ###################################################

  # Create my usual admin user with initial password of `abc123` and build
  # a bare-bones desktop for him, with automatic login.
  ext.youdesk = {
    enable = true;
    username = adminName;
  };

  # Make my admin user a member of the Vbox group too and set up my usual
  # VBox shares for him.
  ext.vbox-shares = {
    names = [ "dropbox" "github" "playground" "projects" ];
    username = adminName;
  };

  # Make my admin use my git config.
  ext.git.config.user = config.users.extraUsers.andrea;

  # Tweak Spacemacs font.
  ext.spacemacs.config.font.size = 36;


  ##########  Desktop Extras  ##################################################

  # Set any of the following to true to enable, see baredesk module.
  ext.baredesk = {
    with-browser = false;    # Use Chrome. NB requires allowUnfree.
    with-launcher = false;   # Use Synapse instead of dmenu.
    with-theme = false;      # Eye candy: Numix theme & icons.
    with-composite = false;  # Eye candy: Compton. NB slows things down in a VM.
  };

}

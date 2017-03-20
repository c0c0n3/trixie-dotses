#
# Main module for `madematix` config.
# Defines the host name and brings in all other modules.
#

{ config, lib, pkgs, ... }:

{

  imports = [
    ./modules/dotses
    ./modules/generic
#    ./hidpi.nix
  ];

  networking.hostName = "madematix";

  ext.swapfile.enable = true;

  # VBox installation:
  # - enable virtualbox guest service (redundant, should already be in
  #     hardware-configuration.nix)
  # - skip fsck on boot cos it won't work with VBox
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;

  # Create my usual admin user with initial password of `abc123` and build
  # a bare-bones desktop for him, with automatic login. Then integrate it
  # into GNOME 3.
  ext.youdesk = {
    enable = true;
    username = "andrea";
  };
  # ext.i3g.enable = true;

  ext.baredesk = {
    with-browser = true;     # requires allowUnfree
    with-launcher = true;
    with-theme = true;
    with-composite = true;
  };
  nixpkgs.config.allowUnfree = true;

  # Make my admin user a member of the Vbox group too.
  users.extraUsers.andrea.extraGroups = [ "vboxsf" ];

  ext.vbox-shares = {
    names = [ "dropbox" "github" "playground" "projects" ];
    user = config.users.extraUsers.andrea;
  };

  ext.git.config.user = config.users.extraUsers.andrea;
#  ext.spacemacs.config.font.size = 36;

/*
  environment.systemPackages = with pkgs; [
    chromium albert synapse
    gnome3.nautilus
    pcmanfm
    remmina
    imagemagick # TODO keep?

  ] ++ config.ext.numix.packages;
*/

}

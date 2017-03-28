#
# Main module for `madematix` config.
# Defines the host name and brings in all other modules.
#
{ config, lib, pkgs, ... }:

{

  imports = [
    ./modules/dotses
    ./modules/generic
    ./boxes/madematix/hidpi.nix
  ];

  ##########  Core System Setup  ###############################################
  networking.hostName = "madematix";
  ext.swapfile.enable = true;
  virtualisation.virtualbox.guest.enable = true;
  boot.initrd.checkJournalingFS = false;
  boot.loader.timeout = 0;

  ##########  Desktop Setup  ###################################################

  ext.yougnomix = {
    enable = true;
    username = "andrea";
  };
  ext.gnomix.gsettings.enable = true;

  users.users.andrea.extraGroups = [ "vboxsf" ];
  ext.vbox-shares = {
    names = [ "dropbox" "github" "playground" "projects" ];
    user = config.users.users.andrea;
  };

  ext.git.config.user = config.users.users.andrea;
  ext.spacemacs.config.font.size = 36;

  environment.systemPackages = [
     (import ./pkgs/themes/flat-remix-gnome-theme.nix)
  ];

}

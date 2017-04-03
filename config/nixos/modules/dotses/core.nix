#
# Minimal system config shared across the board.
#

{ config, pkgs, ... }:

{

  imports = [
      # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # File systems.
  boot.cleanTmpDir = true;
  services.journald.extraConfig = "SystemMaxUse=500M";

  # Locale and time zone.
  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/Paris";

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "17.03";

}

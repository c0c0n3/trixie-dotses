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
  time.timeZone = "Europe/Zurich";

  # Starting from NixOS 19.09, `useDHCP` should be specified separately for
  # each I/F and the global `networking.useDHCP` gets deprecated. But the
  # global `useDHCP` defaults to `true` so we'll have to fake the intended
  # behaviour by setting it to `false` ourselves---this is what the NixOS
  # installer does too when generating the initial system config.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "19.09";

}

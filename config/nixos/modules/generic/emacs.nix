#
# Installs the latest Emacs available in the official Nix repo.
# We install this Emacs derivation system-wide and also make it the derivation
# the built-in Emacs (systemd user) daemon will use if enabled---see NixOS
# `services.emacs` options.
#
{ config, pkgs, lib, ... }:

with lib;
with types;

let
  # NOTE Currently pkgs.emacs points to emacs24 which is why we're using
  # emacs25 below. Change it back to pkgs.emacs when NixOS update it to
  # point to the latest Emacs. Also note that by default the package
  # builds Emacs with GTK 2, so we have to request GTK 3 explicitly.
  latestEmacs = pkgs.emacs25.override {
    withGTK3 = true;
    withGTK2 = false;
  };

in {

  options = {
    ext.emacs.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Installs Emacs 25 built with GTK 3.
      '';
    };
  };

  config = let
    enabled = config.ext.emacs.enable;
  in {
    # If enabled, install our Emacs derivation (Emacs 25 with GTK 3) system
    # wide. Also setup the NixOS built-in Emacs systemd user daemon to use
    # our derivation. This way if the daemon is enabled, it'll use the same
    # package as that used when starting Emacs with a plain `emacs` command.
    # Ditto for our own etermd daemon.
    environment.systemPackages = mkIf enabled [ latestEmacs ];
    services.emacs.package = mkIf enabled latestEmacs;
    ext.etermd.package = mkIf enabled latestEmacs;
  };

}

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
  latestEmacs = pkgs.emacs;  # NOTE (1)
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
# Notes
# -----
# 1. Emacs Override. In NixOS 16.09, `pkgs.emacs` pointed to emacs24 built
# with GTK 2. So I had this override
#
#     latestEmacs = pkgs.emacs25.override {
#       withGTK3 = true;
#       withGTK2 = false;
#     };
#
# to use Emacs 25 with GTK 3. In NixOS 17.03, `pkgs.emacs` is Emacs 25 with
# GTK 3 so I don't need the override anymore. I'm still keeping this module
# though just in case it could be useful going forward. I've opened an issue
# too to remind me:
# - https://github.com/c0c0n3/trixie-dotses/issues/14

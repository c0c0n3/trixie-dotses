#
# A simple system base with a minimal GUI and CLI environment.
# The GUI stack is made up by X, Slim, i3, and the latest Emacs that we use
# both as the system-wide editor and i3 terminal.
# This module just pulls together other modules to install:
#
# * X, Slim, and i3 (`vmx.nix`)
# * latest Emacs (`emacs.nix`)
# * Emacs terminal daemon (`etermd.nix`)
# * Bash completion and a bunch of useful CLI tools (`cli-tools.nix`)
# * Aspell with the English dictionary (`aspell.nix`)
#
# and then makes:
#
# * i3 use the terminal daemon
# * Emacs the default editor system-wide (`EDITOR` environment variable)
#
# You can use this module as a starting point to build a lightweight,
# no-frills desktop.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
let
  paths = import ./paths.nix;
in
{

  options = {
    ext.i3e-base.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install this system base.
      '';
    };
  };

  config = let
    enabled = config.ext.i3e-base.enable;
    emacs = "emacs";                               # NOTE (1)
    terminal = config.ext.etermd.client-cmd-name;  # NOTE (1)
  in (mkIf enabled
  {
    # Install X and i3.
    ext.wmx = {
      enable = true;
      wmName = "i3";
    };

    # Install latest Emacs system-wide.
    ext.emacs.enable = true;

    # Set up an Emacs daemon to open terminal buffers.
    ext.etermd.enable = true;

    # Tell i3 to use our Emacs terminal and make Emacs the default editor
    # system-wide.
    environment.variables = {
      TERMINAL = "${terminal}";
      EDITOR = "${emacs}";
    };

    # Install Aspell with EN dictionary so Emacs can make good use of it.
    ext.aspell.enable = true;

    # Install useful CLI tools and enable Bash completion.
    ext.cli-tools.enable = true;
  });

}
# Notes
# -----
# 1. Command Paths. Should we use absolute paths to the Nix derivations?
# Seems kinda pointless cos these programs will be in the PATH anyway...

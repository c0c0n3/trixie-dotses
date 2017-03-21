#
# A simple system base with a Emacs and CLI environment.
# This module just pulls together other modules to install:
#
# * Latest Emacs (`emacs.nix`)
# * Emacs terminal daemon (`etermd.nix`)
# * Bash completion and a bunch of useful CLI tools (`cli-tools.nix`)
# * Aspell with the English dictionary (`aspell.nix`)
#
# and then makes:
#
# * Emacs the default editor system-wide (`EDITOR` environment variable)
#
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    ext.base.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install this system base.
      '';
    };
  };

  config = let
    enabled = config.ext.base.enable;
    emacs = "emacs";  # NOTE (1)
  in (mkIf enabled
  {
    # Install latest Emacs and make it the default editor system-wide.
    ext.emacs.enable = true;

    # Set up an Emacs daemon to open terminal buffers.
    ext.etermd.enable = true;

    # Make Emacs the default editor system-wide.
    environment.variables = {
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

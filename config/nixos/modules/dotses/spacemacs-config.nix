#
# Install our Spacemacs config in this repo for all users who requested
# Spacemacs, i.e. those in config.ext.spacemacs.users.
#
{ config, pkgs, lib, ... }:

with builtins;
with lib;
with types;
let
  paths = import ./paths.nix;
  dot-link = import ../generic/dot-link-utils.nix;
in {

  options = {
    ext.spacemacs.config.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install our Spacemacs config for all ext.spacemacs.users.
      '';
    };
    ext.spacemacs.config.font.family = mkOption {
      type = string;
      default = "Source Code Pro";
      description = ''
        Makes Spacemacs use this font.
      '';
    };
    ext.spacemacs.config.font.size = mkOption {
      type = int;
      default = 17;
      description = ''
        Makes Spacemacs use this font size.
      '';
    };
    ext.spacemacs.config.font.weight = mkOption {
      type = string;
      default = "normal";
      description = ''
        Makes Spacemacs use this font weight.
      '';
    };
    ext.spacemacs.config.font.width = mkOption {
      type = string;
      default = "normal";
      description = ''
        Makes Spacemacs use this font width.
      '';
    };
    ext.spacemacs.config.font.powerline-scale = mkOption {
      type = string;
      default = "1.1";
      description = ''
        Makes Spacemacs use this powerline-scale.
      '';
    };
  };

  config = let
    enabled = length users != 0 && config.ext.spacemacs.config.enable;
    users = config.ext.spacemacs.users;
    font = config.ext.spacemacs.config.font;
  in (mkIf enabled {
    # Sym-link our Spacemacs config into homes.
    ext.dot-link.files = dot-link.mkLinks users [
      { src = paths.config ".spacemacs.d"; }
    ];
    # NB does nothing if users == [].

    # We use these fonts in our Spacemacs config.
    fonts.fonts = mkIf enabled [ pkgs.source-code-pro ];

    # Use SPACEFONT to set Spacemacs font params. (See our editor/theme.el)
    environment.variables = {
      SPACEFONT = concatStrings [       # NOTE (1)
        "'("
        ''\"${font.family}\"''          # NOTE (2)
        " :size ${toString font.size}"
        " :weight ${font.weight}"
        " :width ${font.width}"
        " :powerline-scale ${font.powerline-scale}"
        ")"
      ];
    };
  });

}
# Notes
# -----
# 1. Global Env. Users can redefine SPACEFONT if they want e.g. a different
# font size.
# 2. Bash Escaping. Need to escape " to make it work in Bash. In fact, under
# the bonnet NixOS will turn
#
#     environment.variables = { X = "y"; };
#
# into a Bash statement in the init script
#
#     export X="y";
#
# So we have to escape to make sure our SPACECONF looks like this
#
#     SPACEFONT="'(\"font family\" :size ...)"
#

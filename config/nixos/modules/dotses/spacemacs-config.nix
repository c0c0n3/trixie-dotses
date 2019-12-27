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
      type = str;
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
      type = str;
      default = "normal";
      description = ''
        Makes Spacemacs use this font weight.
      '';
    };
    ext.spacemacs.config.font.width = mkOption {
      type = str;
      default = "normal";
      description = ''
        Makes Spacemacs use this font width.
      '';
    };
    ext.spacemacs.config.font.powerline-scale = mkOption {
      type = str;
      default = "1.1";
      description = ''
        Makes Spacemacs use this powerline-scale.
      '';
    };
    ext.spacemacs.config.with-etermd = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to start etermd and make it use our Spacemacs config.
      '';
    };
  };

  config = let
    enabled = length users != 0 && config.ext.spacemacs.config.enable;
    users = config.ext.spacemacs.users;
    font = config.ext.spacemacs.config.font;
    with-etermd = config.ext.spacemacs.config.with-etermd;
    etermd = config.ext.etermd.daemon-name;
  in (mkIf enabled {

    # Sym-link our Spacemacs config into homes.
    ext.dot-link.files = dot-link.mkLinks users [
      { src = paths.config ".spacemacs.d"; }
    ];
    # NB does nothing if users == [].

    # We use these fonts in our Spacemacs config.
    # See: .spacemacs.d/editor/theme.el
    fonts.fonts = mkIf enabled (with pkgs; with config.ext.pkgs; [
      source-code-pro
      emacs-all-the-icons
    ]);

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

    # If requested, set up an Emacs daemon to open terminal buffers. We do this
    # cos we wanna use the Spacemacs config but Spacemacs is a bit slow when
    # starting up. Luckily the daemon makes opening a terminal lightning fast!
    # SPACECONF makes the daemon use our Spacemacs terminal config.
    ext.etermd.enable = with-etermd;
    systemd.user.services."${etermd}".environment = mkIf with-etermd {
      SPACECONF="etermd";
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

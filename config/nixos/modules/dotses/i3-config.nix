#
# i3 desktop configuration.
# This module configures i3 for each given user with our i3 config in this
# repo.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
let
  paths = import ./paths.nix;
  dot-link = import ../generic/dot-link-utils.nix;
in {

  options = {
    ext.i3.config.users = mkOption {
      type = listOf attrs;
      default = [ ];
      description = ''
        Users for who to implement our i3 config.
      '';
    };
    ext.i3.config.wallpaper = mkOption {
      type = path;
      default = null;
      description = ''
        Path to the desktop wallpaper to use.
      '';
    };
    ext.i3.config.editor = mkOption {
      type = string;
      default = "";
      description = ''
        If specified, it must be a command name, e.g. 'emacs', that our i3
        config will bind to the editor key. (See: config/i3/config)
      '';
    };
    ext.i3.config.browser = mkOption {
      type = string;
      default = "";
      description = ''
        If specified, it must be a command name, e.g. 'chromium', that our i3
        config will bind to the Web browser key. (See: config/i3/config)
      '';
    };
    ext.i3.config.launcher = mkOption {
      type = string;
      default = "";
      description = ''
        If specified, it must be a command name, e.g. 'synapse', that our i3
        config will bind to the app launcher key. (See: config/i3/config)
      '';
    };
  };

  config = let
    enabled = length cfg.users != 0;
    cfg = config.ext.i3.config;

    links = [
        { src = paths.config "/i3/i3status.conf"; dst =".config/i3/"; }
        { src = paths.config "/i3/config"; dst =".config/i3/"; }
    ] ++ (
      if cfg.wallpaper != null then [
        { src = cfg.wallpaper; dst =".config/wallpaper"; } ]
      else []
    );
  in {
    # Add i3 implicit dependencies to your system path: these programs are
    # used by our i3 config so have to be available.
    environment.systemPackages = mkIf enabled (with pkgs; [
      i3status dmenu  # NOTE (1)
      feh             # NOTE (2)
    ]);

    # We use these fonts in the i3 config file.
    fonts.fonts = mkIf enabled (with pkgs; [
      font-awesome ubuntu_font_family
    ]);

    # Sym-link i3 config into homes.
    # NB does nothing if users == [].
    ext.dot-link.files = dot-link.mkLinks cfg.users links;

    # Tell our i3 config to use any of the specified programs.
    environment.variables =
      (if cfg.launcher != "" then { I3_LAUNCHER = "${cfg.launcher}"; } else {})
      //
      (if cfg.browser != "" then { I3_BROWSER = "${cfg.browser}"; } else {})
      //
      (if cfg.editor != "" then { I3_EDITOR = "${cfg.editor}"; } else {});
  };

}

# Notes
# -----
# 1. The i3 module (nixpkgs[..]/window-managers/i3.nix) adds pkgs.i3 to
# systemPackages; pkgs.i3 depends on i3status and dmenu. But if we don't
# add these 2 explicitly here, they won't be available in the system path:
# yip, the binaries are there but they don't get a corresponding sym-link
# in /run/current-system/sw/bin.
#
# 2. Have to install feh cos we use it in i3 config to set the wallpaper.
# Setting the wallpaper before starting i3 will make feh use the wrong screen
# resolution as you can see by removing the code from i3 config and using this
# instead:
#
# displayManager.sessionCommands = let
#   user = config.users.users.andrea;
# in ''
#    WALLPAPER="${user.home}/.config/wallpaper"
#    [ -f $WALLPAPER ] && feh --no-fehbg --bg-scale $WALLPAPER
# '';

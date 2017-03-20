#
# Bare-bones desktop.
# A simple GUI running X with i3, spiced up with Spacemacs and useful CLI
# tools. This module enables i3e-base and then uses our i3, Spacemacs, and
# Bash dotses modules to configure i3, Emacs and Bash for a set of users.
# In particular:
#
# * Emacs becomes Spacemacs;
# * `etermd` uses our Spacemacs terminal config, so when you start a terminal
#    from i3, you get our Spacemacs terminal;
# * the i3 editor key starts our Spacemacs editor;
#
# Oh, we've got some bolt-on accessories as well: a browser, an app launcher,
# some eye candy---see options below.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
let
  paths = (import ./paths.nix);
in
{

  options = {
    ext.baredesk.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to get a bare-bones desktop running X with i3 and Emacs
        as editor and terminal. In this same goodie bag, you'll also find
        some useful CLI tools.
      '';
    };
    ext.baredesk.users = mkOption {
      type = listOf attrs;
      default = [];
      description = ''
        List of users who want this desktop configured with the dot files in
        this repo: i3, Spacemacs, and Bash.
      '';
    };
    ext.baredesk.with-browser = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install Google Chrome and bind it to the i3 browser key
        in our i3 config. Chrome doesn't come with a free license, so you'll
        get an installation error unless you've enabled `allowUnfree`.
      '';
    };
    ext.baredesk.with-launcher = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install Synapse and bind it to the i3 app launcher key
        in our i3 config.
      '';
    };
    ext.baredesk.with-theme = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install the Numix GTK 3 theme and icons.
        NB you shouldn't enable this if you also have GNOME 3, rather set
        theme & icon using GNOME's own tools.
      '';
    };
    ext.baredesk.with-composite = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install and run Compton.
      '';
    };
  };

  config = let
    cfg = config.ext.baredesk;
  in (mkIf cfg.enable
  {
    # Install a system base with i3, Emacs, and useful CLI tools.
    ext.i3e-base.enable = true;

    # Install our i3 config for all specified users, set a default wallpaper,
    # and make i3 launch Spacemacs when hitting the editor key.
    ext.i3.config = {
      users = cfg.users;
      wallpaper = paths.wallpapers
        "/4ever.eu.splash,-atomic-explosion,-water-148870.jpg";
      editor = "emacs";
    };

    # Install Spacemacs with our config for all specified users and enable the
    # terminal daemon, making it use our Spacemacs terminal config.
    ext.spacemacs.users = cfg.users;
    ext.spacemacs.config.enable = true;
    ext.spacemacs.config.with-etermd = true;

    # Install our Bash config for all specified users.
    ext.bash.config.users = cfg.users;

    # Install browser and/or app launcher if requested.
    environment.systemPackages = with pkgs;
     (if cfg.with-browser then [ google-chrome ] else []) ++
     (if cfg.with-launcher then [ synapse ] else []);

    # Hook browser and/or app launcher into i3 if requested.
    ext.i3.config.browser = mkIf cfg.with-browser "google-chrome-stable";
    ext.i3.config.launcher = mkIf cfg.with-launcher "synapse";

    # Install & configure the theme if requested.
    ext.gtk3.users = mkIf cfg.with-theme cfg.users;
    ext.numix.enable = cfg.with-theme;

    # Enable composition if requested.
    services.compton = mkIf cfg.with-composite {
      enable = true;
      fade = true;
      inactiveOpacity = "0.9";
      menuOpacity = "0.95";
    };
  });

}

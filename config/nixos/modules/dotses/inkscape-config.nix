#
# Install our Inkscape config for all users who request it.
# Note we don't install a `preferences.xml` file too, you'll have to do that
# yourself---see `config/inkscape/preferences`.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
let
  paths = import ./paths.nix;
  dot-link = import ../generic/dot-link-utils.nix;
in {

  options = {
    ext.inkscape.config.users = mkOption {
      type = listOf attrs;
      default = [ ];
      description = ''
        Users who want to install our Inkscape config.
      '';
    };
  };

  config = let
    enabled = length users != 0;
    users = config.ext.inkscape.config.users;
    links = [
      { src = paths.config "/inkscape/doc-templates/Blackboard.svg";
          dst = ".config/inkscape/templates/"; }
      { src = paths.config "/inkscape/palettes/pastel.gpl";
          dst = ".config/inkscape/palettes/"; }
    ];
  in mkIf enabled {
    # Sym-link Inkscape config into homes.
    # NB does nothing if users == [].
    ext.dot-link.files = dot-link.mkLinks users links;

    # We use these fonts in the Inkscape prefs files.
    fonts.fonts = [ config.ext.pkgs.kg-miss-speechy-ipa ];  # NOTE (2)
  };

}
# Notes
# -----
# 1. Preferences File. We could easily sym-link one from
#
#     config/inkscape/preferences
#
# but Inkscape will reshuffle the tags, even if you add no new settings from
# the UI. So it's kinda pointless to sym-link it from our git repo to track
# changes.
#
# 2. Fonts. We also install the font used in the preference files noted in
# (1). Even though we don't sym link those files, it's convenient to have
# the font ready for use.

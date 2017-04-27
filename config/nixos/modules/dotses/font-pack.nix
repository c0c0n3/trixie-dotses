#
# Install a selection of fonts I've used for various things.
# See:
# - https://github.com/c0c0n3/trixie-dotses/blob/master/install-guides/mactop/apps.md#fonts
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    ext.fonts.font-pack.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enable it to install my selection of fonts.
      '';
    };
  };

  config = let
    enabled = config.ext.fonts.font-pack.enable;
  in mkIf enabled {
    fonts.fonts = with pkgs; with config.ext.pkgs; [
      alegreya alegreya-sans
      cherry-cream-soda
      emacs-all-the-icons
      kaushan-script
      kg-miss-speechy-ipa
      sansita-one
      source-code-pro
      ubuntu_font_family
    ];
  };

}

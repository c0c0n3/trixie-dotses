#
# HiDPI tweaks.
# The HP ZBook 15 has a nominal PPI of 142 but for some reason X doesn't
# pick it up correctly so I end up with a DPI of 96. This module fixes
# that.
#
{ config, lib, pkgs, ... }:

with lib;
with types;
{

  options = {
    ext.hidpi.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Enables HiDPI tweaks.
      '';
    };
  };

  config = let
    enabled = config.ext.hidpi.enable;
  in (mkIf enabled {

    # Force screen resolution and DPI cos X doesn't get it right.
    services.xserver = {  # NOTE (1) (2)
      monitorSection = ''
        DisplaySize    340 190
        Option "DPI" "142 x 142"
        Option "UseEdidDpi" "FALSE"
      '';
    };

  });

}
# Notes
# -----
# 1. HP ZBook 15 specs:
# - http://h20195.www2.hp.com/v2/GetPDF.aspx/c04111353
#
# 2. NVidia DPI settings:
# - http://http.download.nvidia.com/XFree86/Linux-x86/1.0-8178/README/appendix-y.html
#

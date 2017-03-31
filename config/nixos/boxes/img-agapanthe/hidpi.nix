#
# HiDPI tweaks.
# The HP ZBook 15 has a nominal PPI of 142 but for some reason X doesn't
# pick it up correctly so I end up with a DPI of 96. This module fixes
# that.
# TODO hell no, it doesn't! I'm still stuck with 96...see notes below.
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
        DisplaySize    344 194
        Option "DPI" "143x144"
        Option "UseEdidDpi" "FALSE"
      '';
    };

    # Also add the DPI value to the X command line.
    services.xserver.dpi = 144;
  });

}
# Notes
# -----
# 1. DPI Issue. Under GNOME I get a DPI of 96 as reported by
#
#     $ xdpyinfo | grep reso
#
# This happens both with GDM+GNOME and Slim+GNOME. But if I boot into Slim+i3,
# then `xdpyinfo` reports a DPI of `143x144` which seems pretty much right.
# So the question is why X doesn't seem to get the DPI right when running
# GNOME? By default NixOS doesn't add a DPI argument to the command line
# that starts X from the DM (see the `services.xserver` module) so X can
# actually figure it out by itself it seems?
# Note that forcing the DPI from the command line in GNOME
#
#     $ xrandr --dpi 143x144
#
# works...
#
# 2. DPI Forcing. So I've tried to set the DPI myself using the code up there,
# but am still stuck with 96 in GNOME, i.e. for some obscure reason X seems to
# ignore both the MonitorSection directive and the explicit DPI command line
# param. Anyhoo, I'm gonna note here where the settings you see up there come
# from. First off, the HP ZBook 15 specs
# - http://h20195.www2.hp.com/v2/GetPDF.aspx/c04111353
# give an active area of 34.4 x 19.4 cm, so that's what I'm using for the
# DisplaySize. They also say the PPI is 142, but like I said `xdpyinfo` reports
# `143x144` which seems more accurate, so I'm using this value instead and 144
# for the X command line. The NVidia docs on DPI explain why I had to set the
# other options and what they're for:
# - http://http.download.nvidia.com/XFree86/Linux-x86/1.0-8178/README/appendix-y.html

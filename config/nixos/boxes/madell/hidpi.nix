#
# HiDPI tweaks.
# Enabling HiDPI in VBox gets us way better resolution but to take advantage
# of it we need some additional tweaks.
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

    # Force screen resolution and DPI as X doesn't get it right.
    # NOTE (1)
    services.xserver = {
      monitorSection = ''
        DisplaySize    345 194
      '';
    };

    # Tweak GTK apps for HiDPI.
    # NOTE (2)
    environment.variables = {
      GDK_SCALE = "4";
    };

    # Force KMS.
    # NOTE (3)
    boot.kernelParams = [ "video=3840x2160" ];

  });

}
# Notes
# -----
# 1. X Display Size. Without this, things, (esp. fonts) are gonna look
# blurry/tiny. My Dell XPS 15 has a monitor resolution of 3840x2160.
# I'm using VBox unscaled HiDPI output and, after making the VM window go
# full screen in the host, `xrandr` reports a resolution of 3840x2160 from
# the  NixOS guest, which is right. X also reports the same resolution but
# uses a low DPI (96), see the output of
#
#     $ xdpyinfo | grep -B 2 resolution
#
# To fix this, I've computed the actual dims myself:
#
#     $ echo 'scale=5;sqrt(3840^2+2160^2)' | bc
#     4405.81434
#     $ echo 'scale=5;(15.6/4406)*3840*25.4' | bc
#     345.27744
#     $ echo 'scale=5;(15.6/4406)*2160*25.4' | bc
#     194.21856
#
# See:
# - https://wiki.archlinux.org/index.php/Xorg#Display_size_and_DPI
#
# 2. GTK Scale. Without it, GTK apps will be too small. Some apps like i3
# and Chromium use the DPI given by X, so (1) fixes them being too small.
# See:
# - https://wiki.archlinux.org/index.php/HiDPI
#
# 3. KMS. Without this the virtual console is tiny. With the VM shutdown:
#
#  $ VBoxManage setextradata "madell" VBoxInternal2/EfiGraphicsResolution 3840x2160
#
# This sets the framebuffer resolution in EFI to 3840x2160 as explained in
# the VBox manual:
#
# - https://www.virtualbox.org/manual/ch03.html#efividmode
#
# The above gives you a 3840x2160 resolution during boot, but without the
# following
#
#  $ VBoxManage setextradata "madell" "CustomVideoMode1" "3840x2160x32"
#
# if you log into a virtual console you'll see for some reason the resolution
# is much less than that. The above command and the boot param fix it. The
# only problem I'm still having is the tiny font but it looks like the default
# 16pt font is the largest available on my system. Didn't bother to find out
# if I can install a font with a bigger size.
# See
# - https://wiki.archlinux.org/index.php/VirtualBox#Set_optimal_framebuffer_resolution
#

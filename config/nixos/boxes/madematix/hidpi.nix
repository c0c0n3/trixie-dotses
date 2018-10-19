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
        DisplaySize    331 207
      '';
      dpi = 221;
    };

    # Tweak GTK apps for HiDPI.
    # NOTE (2)
#    environment.variables = {
#      GDK_SCALE = "2";
#    };

    # Force KMS.
    # NOTE (3)
    boot.kernelParams = [ "video=1920x1200" ];

  });

}
# Notes
# -----
# 1. X Monitor Settings. Without this, things, (esp. fonts) will look blurry.
# My MacBook Pro Retina 15 has a monitor resolution of 2880x1800 at 220 PPI.
# (As per Apple's specs, but actual PPI seems 220.53, see link below.)
# I'm using VBox unscaled HiDPI output and, after maximising the VM window
# to fit the screen, `xrandr` reports a resolution of 2880x1660 from the
# NixOS guest. (Think this is cos VBox subtracts automatically the title
# and status bar vertical sizes from the total vertical screen size available
# to the guest.) This should be right, but X seems to think the screen is
# way bigger than it is and also uses a low DPI (96), see the output of
#
#     $ xdpyinfo | grep -B 2 resolution
#
# If I enter full-screen mode, then the reported resolution becomes 2880x1800
# (correct!) but I'm still stuck with the low DPI (96).
# To fix this, I've computed myself the actual dims for a maximised VM window:
#
#     $ echo 'scale=5;sqrt(2880^2+1800^2)' | bc
#     3396.23320
#     $ echo 'scale=5;(15.4/3396)*2880*25.4' | bc
#     331.37856
#     $ echo 'scale=5;(15.4/3396)*1660*25.4' | bc
#     191.00292
#
# To get the dims for a VM in full-screen mode, use the first two computations
# above but replace the last with:
#
#     $ echo 'scale=5;(15.4/3396)*1800*25.4' | bc
#     207.11160
#
# Given the dims, X should be able to compute the DPI. So why force it with
# the `dpi` param above? (BTW, it gets turned into a CLI arg of `-dpi 221`
# and then used to start X---see `xserver.nix` module.) Turns out X computes
# a DPI of 96 after booting but if I reboot the system or just restart the
# display manager
#
#     $ sudo systemctl restart display-manager
#
# then the DPI becomes 221. Funny thing is, in NixOS 17.03 I didn't need to
# set the DPI myself. In fact, a ` DisplaySize 331 207` directive was enough
# for X set the DPI to 221 on the first shot, after booting the system.
#
# See:
# - https://wiki.archlinux.org/index.php/Xorg#Display_size_and_DPI
# - https://pixensity.com/list/apple-macbook-pro-15-inch-retina-display-16/
#
# 2. GTK Scale. Without it, some GTK apps were too small on NixOS 17.03. This
# isn't the case anymore on NixOS 18.09, so I'm commenting it out for now.
# Note that some apps like i3 and Chromium use the DPI given by X instead, so
# (1) fixes them being too small.
# See:
# - https://wiki.archlinux.org/index.php/HiDPI
#
# 3. KMS. Without this the virtual console is tiny. With the VM shutdown:
#
#  $ VBoxManage setextradata "madematix" VBoxInternal2/EfiGraphicsResolution 1920x1200
#
# (For older versions of VBox use `VBoxInternal2/EfiGopMode 5` instead.)
# This sets the framebuffer resolution in EFI to 1920x1200 as explained in
# the VBox manual:
#
# - https://www.virtualbox.org/manual/ch03.html#efividmode
#
# The above gives you a 1920x1200 resolution during boot, but without the
# following
#
#  $ VBoxManage setextradata "madematix" "CustomVideoMode1" "1920x1200x24"
#
# if you log into a virtual console you'll see for some reason the resolution
# is much less than that. The above command and the boot param fix it. The
# only problem I'm still having is the tiny font but it looks like the default
# 16pt font is the largest available on my system. Didn't bother to find out
# if I can install a font with a bigger size.
# See
# - https://wiki.archlinux.org/index.php/VirtualBox#Set_optimal_framebuffer_resolution
#
# A final note. The reason I used a 1920x1200 resolution is that at the time
# it was the largest VBox supported, now you have plenty more so you may want
# to try your luck with a higher resolution and custom video mode of 32 bpp
# rather than 24 as in `CustomVideoMode1 1920x1200x32`.

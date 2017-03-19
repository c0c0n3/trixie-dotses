#
# HiDPI tweaks.
# Enabling HiDPI in VBox gets us way better resolution but to take advantage
# of it we need some additional tweaks.
#
{ config, lib, pkgs, ... }:

{

  # Force screen resolution and DPI as X doesn't get it right.
  # NOTE (1)
  services.xserver = {
    monitorSection = ''
        DisplaySize    331 191
    '';
  };

  # Tweak GTK apps for HiDPI.
  # NOTE (2)
  environment.variables = {
    GDK_SCALE = "2";
  };

  # Force KMS.
  # NOTE (3)
  boot.kernelParams = [ "video=1920x1200" ];

}
# Notes
# -----
# 1. X Display Size. Without this, things, (esp. fonts) are gonna look
# blurry. My MacBook Pro Retina 15 has a monitor resolution of 2880x1800.
# I'm using VBox unscaled HiDPI output and, after maximising the VM window
# to fit the screen, `xrandr` reports a resolution of 2880x1660 from the
# NixOS guest. (Think this is cos VBox subtracts automatically the title
# and status bar vertical sizes from the total vertical screen size available
# to the guest.) This should be right, but X seems to think the screen is
# way bigger than it is and also uses a low DPI (96), see the output of
#
#     $ xdpyinfo | grep -B 2 resolution
#
# To fix this, I've computed the actual dims myself:
#
#     $ echo 'scale=5;sqrt(2880^2+1800^2)' | bc
#     3396.23320
#     $ echo 'scale=5;(15.4/3396)*2880*25.4' | bc
#     331.37856
#     $ echo 'scale=5;(15.4/3396)*1660*25.4' | bc
#     191.00292
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
#  $ VBoxManage setextradata "madematix" VBoxInternal2/EfiGopMode 5
#
# The above sets the framebuffer resolution in EFI to 1920x1200 which is the
# largest mentioned in the VBox manual:
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

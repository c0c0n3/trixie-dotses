# Usage:
#
#   environment.systemPackages = [
#     (import ./pkgs/zoom-us.nix)
#   ];
#
with import <nixpkgs> { };  # NOTE (1)

stdenv.mkDerivation rec {

  name = "zoom-us";
  meta = {
   homepage = http://zoom.us;
   description = "zoom.us instant messenger";
   # license = stdenv.lib.licenses.unfree;  # NOTE (6)
   platforms = stdenv.lib.platforms.linux;
  };

  version = "2.0.87130.0317";  # NOTE (2)
  src = fetchurl {             # NOTE (3)
    # url = "https://zoom.us/client/${version}/zoom_${version}_x86_64.tar.xz";
    url = https://zoom.us/client/latest/zoom_x86_64.tar.xz;
    sha256 = "bcd08604788a2506fde54241ca79a65acea87c002aaad8af9e5acf927e29cc9c";
  };

  phases = [ "unpackPhase" "installPhase" ];
  nativeBuildInputs = [ qt5.makeQtWrapper ];
  libPath = stdenv.lib.makeLibraryPath [  # NOTE (4)
    alsaLib
    gcc.cc
    glib
    gst_plugins_base
    gstreamer
    icu
    libpulseaudio
    libuuid
    libxml2
    libxslt
    qt5.qtbase
    qt5.qtdeclarative
    qt5.qtscript
    qt5.qtwebchannel
    qt5.qtwebengine
    qt5.qtwebkit
    sqlite
    xlibs.xcbutilkeysyms
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXext
    xorg.libXfixes
    xorg.libXrender
    xorg.xcbutilimage
    zlib
  ];

  # NOTE (5)
  installPhase = ''
    INSTDIR=$out/share
    INTERP=$(cat $NIX_CC/nix-support/dynamic-linker)
    RPATH="${libPath}:$INSTDIR"

    mkdir -p $INSTDIR
    # rm lib*                 # NOTE (4)
    cp -r * $INSTDIR

    patchelf --set-interpreter "$INTERP" --set-rpath "$RPATH" "$INSTDIR/zoom"
    wrapQtProgram "$INSTDIR/zoom"
    mkdir -p $out/bin
    ln -s "$INSTDIR/zoom" $out/bin/zoom-us
  '';

}
# Notes
# -----
# 1. Zoom-us gone missing. NixOS 16.09 used to have a `zoom-us` package:
# - https://github.com/NixOS/nixpkgs/blob/release-16.09/pkgs/applications/networking/instant-messengers/zoom-us/default.nix
# but it's not in 17.03, desaparecido. So I've lifted the 16.09 package and
# tried to make it work with 17.03. Bear in mind this is a cheap **hack**,
# it should go out the window as soon as the official package becomes available
# again!
#
# 2. Version. If you download and extract the tarball, you'll find a
# `version.txt` file with the version number in it.
#
# 3. Download URL. Ideally we should download the version bundle for the
# version we've declared, but the link they used in 16.09 is broken and
# I couldn't bother to find out if Zoom actually still makes client bundles
# available by their corresponding version number.
#
# 4. Library deps. Not sure what they are exactly. The original list in the
# 16.09 package is incomplete which I only realised after I started Zoom and
# the loader puked all over me. So I've added some missing libs to the list,
# but then decided to take a shortcut and install all the libs Zoom ships in
# its tarball, adding the install dir to $RPATH. The horror!
#
# 5. Nixifying Zoom. As far as I can tell, it takes at least some ELF patching
# and using of `wrapQtProgram`. My code is basically a fat copy & paste (TM)
# from the 16.09 package, but after scratching around a bit, this seems to me
# a better way of doing things:
# - https://github.com/NixOS/nixpkgs/blob/release-17.03/pkgs/applications/networking/dropbox/default.nix
# Also, there's a few shell scripts in the zoom tarball that need patching
# cos they use `/bin/sh`. The nixpkgs manual says this could be done
# automagically by the fixup phase. Anyhoo, the program seems to work for
# now so I'm not gonna bother.
#
# 6. License. The 16.09 package declared an "unfree" license. I should do that
# too, but if I comment that line in, Nix refuses to build even with
#
#     nixpkgs.config.allowUnfree = true;
#
# Didn't have time to figure this out, so I'm leaving the license stuff out
# for now.

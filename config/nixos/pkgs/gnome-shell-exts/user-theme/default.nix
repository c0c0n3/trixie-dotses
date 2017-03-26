# Usage:
#
#   environment.systemPackages = [
#     (import ./pkgs/gnome-shell-exts/user-theme)
#   ];
#   services.xserver.desktopManager.gnome3.sessionPath = [
#     (import ./pkgs/gnome-shell-exts/user-theme)
#   ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "user-theme-3.20.0";

  src = ./as-installed-by-tweak-tool.tgz;  # TODO see NOTE (1)

  uuid = "user-theme@gnome-shell-extensions.gcampax.github.com";

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    INSTALL_DIR=$out/share/gnome-shell/extensions/${uuid}
    mkdir -p $INSTALL_DIR
    cp -r * $INSTALL_DIR

    INSTALL_SCHEMA_DIR=$out/share/gsettings-schemas/${name}/glib-2.0
    mkdir -p $INSTALL_SCHEMA_DIR
    ln -s $INSTALL_DIR/schemas $INSTALL_SCHEMA_DIR
  '';

}
# Notes
# -----
# 1. Sources. The tarball I have here is what the Tweak Tool installed through
# the browser plugin. (I stripped out the locale directory to save a couple of
# megs.) The User Themes extension is part of the GNOME Shell Extensions repo:
# - https://github.com/GNOME/gnome-shell-extensions
# and there's a `gnome-shell-extensions` Nix package that builds most of the
# extensions in that repo, except for the User Themes! Dunno why. Anyhoo, I
# should figure out how to build from sources myself or hack the existing
# `gnome-shell-extensions` package to make it build the User Themes as well.
# Then get rid of the tarball in this dir!!!
#
# 2. GSettings Schema Compilation. For now it's not needed cos the compiled
# schema is in the tarball. But if I end up building myself from source I
# might need to compile the XML schema if the makefile doesn't do that.
# Here's an example of how to do it in NixOS:
# - https://github.com/NixOS/nixpkgs/blob/release-16.09/pkgs/desktops/gnome-3/extensions/system-monitor.nix
#
# 3. GSettings Schema Linking. We symlink the schema in the out dir using the
# path GSettings expects, but the out dir still needs to be added to the list
# in $XDG_DATA_DIRS before GSettings can actually find the schema. You do this
# by adding this package to:
#
#      services.xserver.desktopManager.gnome3.sessionPath
#
# as noted above. If you look at the gnome3 module, you'll see they scan all
# those package directories to populate $XDG_DATA_DIRS.

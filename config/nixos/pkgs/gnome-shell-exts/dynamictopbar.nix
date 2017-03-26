# Usage:
#
#   environment.systemPackages = [
#     (import ./pkgs/gnome-shell-exts/dynamictopbar.nix)
#   ];
#   services.xserver.desktopManager.gnome3.sessionPath = [
#     (import ./pkgs/gnome-shell-exts/dynamictopbar.nix)
#   ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "dynamictopbar-19";

  src = fetchgit {
    url = https://github.com/AMDG2/GnomeShell_DynamicTopBar.git;
    sha256 = "09fvmy22127mghb0k6svlrabd2qw5r3raxr0x9qm0kni8f5fflcb";
  };

  uuid = "dynamicTopBar@gnomeshell.feildel.fr";

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    INSTALL_DIR=$out/share/gnome-shell/extensions/
    mkdir -p $INSTALL_DIR
    cp -r ${uuid} $INSTALL_DIR

    INSTALL_SCHEMA_DIR=$out/share/gsettings-schemas/${name}/glib-2.0
    mkdir -p $INSTALL_SCHEMA_DIR
    ln -s $INSTALL_DIR/${uuid}/schemas $INSTALL_SCHEMA_DIR
  '';

}
# Notes
# -----
# 1. GSettings Schema Compilation. Not needed for this extension cos it comes
# with a pre-compiled GSettings schema---look into the `schemas` subdir.
#
# 2. GSettings Schema Linking. We symlink the schema in the out dir using the
# path GSettings expects, but the out dir still needs to be added to the list
# in $XDG_DATA_DIRS before GSettings can actually find the schema. You do this
# by adding this package to:
#
#      services.xserver.desktopManager.gnome3.sessionPath
#
# as noted above. If you look at the gnome3 module, you'll see they scan all
# those package directories to populate $XDG_DATA_DIRS.

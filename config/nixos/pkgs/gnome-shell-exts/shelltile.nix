# Usage:
#
#   environment.systemPackages = [
#     (import ./pkgs/gnome-shell-exts/shelltile.nix)
#   ];
#   services.xserver.desktopManager.gnome3.sessionPath = [
#     (import ./pkgs/gnome-shell-exts/shelltile.nix)
#   ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "shelltile-3.22";  # NOTE (1)

  src = fetchgit {
    url = https://github.com/emasab/shelltile.git;
    rev = "0ece8f1e53ad94f8c95d4d3a5e887868547bb346";
    sha256 = "0iclfrbdxkhb4bwnmbvvnmf1w42a5kg35hkmk50pzlrcfny9jifi";
  };

  uuid = "ShellTile@emasab.it";

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
# 1. Shelltile Version. Couldn't find any version info but according to the
# metadata file, 3.22 is the highest GNOME version Shelltile's compatible with.
# So I'm using that version number for lack of better options.
#
# 2. GSettings Schema Compilation. Not needed for this extension cos it comes
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

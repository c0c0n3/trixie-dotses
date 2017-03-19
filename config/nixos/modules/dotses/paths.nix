#
# Helper functions to work with paths in this repo.
#
with import <nixpkgs> {};
with pkgs.lib;
with (import ../generic/path-utils.nix);
rec {

  # Path to this repo's root directory.
  baseDir = ../../../..;
  # NOTE if you move this file around, you'll have to adjust this baseDir
  # path accordingly! Hell, isn't there a better way of doing this?!

  # Joins the string path s to this repo's base dir.
  # Bombs out if the resulting path doesn't exist.
  dotses = s: let
    p = join baseDir s;
  in assert pathExists p; p;

  # Joins the string path s to this repo's config dir.
  # Bombs out if the resulting path doesn't exist.
  config = s: join (dotses "config") s;

  # Joins the string path s to this repo's wallpapers dir.
  # Bombs out if the resulting path doesn't exist.
  wallpapers = s: join (dotses "wallpapers") s;

}

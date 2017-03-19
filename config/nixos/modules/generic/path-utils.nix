#
# Helper functions to work with paths.
#
with import <nixpkgs> {};
with pkgs.lib;
rec {
  # Joins the string path s to the base path p in a path p/s.
  # If s is empty, we return p. Also s can begin with a slash, e.g.
  # join /x "/y" == /x/y == join /x "y".
  join = p: s: p + ("/" + s);
  # NOTE the reason why we don't join two paths using plain + is that in
  # some cases the second path may need escaping e.g.
  # ../../wallpapers + /4ever.eu.splash,-atomic-explosion,-water-148870.jpg
  # won't work cos of the commas, but
  # ../../wallpapers + "/4ever.eu.splash,-atomic-explosion,-water-148870.jpg"
  # actually works.

  # Is the string path s absolute?
  isAbs = s: substring 0 1 s == "/";
  # NOTE substring indexes
  # We use substring ignoring corner cases where the indexes are out of range
  # cos substring returns an empty string in those cases, e.g.
  # substring 1 2 "" == "".
}

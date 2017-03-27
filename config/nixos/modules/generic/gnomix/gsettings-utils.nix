#
# Utils for the various gsettings-* modules.
#
with import <nixpkgs> {};

{
  # gsettings command to set a value.
  set = "${pkgs.glib.dev}/bin/gsettings set";

  # converts a boolean to it string rep.
  toBool = b : if b then "true" else "false";
}

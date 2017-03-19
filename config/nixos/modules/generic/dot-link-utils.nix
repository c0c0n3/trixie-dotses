#
# Util functions to help with dot-link configuration.
#
with import <nixpkgs> {};
with pkgs.lib;
rec {

  # Helper function to set up links shared by a list of users.
  # Typical usage (pseudo code):
  #
  #   let d = (import [...]/dot-link-utils.nix)
  #   ext.dot-link.files = d.mkLinks users shared-links
  #
  # NB does nothing if users == [].
  mkLinks = users: lnks:
  let
    mk = usr: { user = usr; links = lnks; };
  in map mk users;

}

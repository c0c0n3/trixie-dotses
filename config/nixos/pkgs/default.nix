#
# Puts together all our custom packages so we can bring them all into scope
# with a single statement.
# Example usage:
#
#     with import ./pkgs;
#
# or `../pkgs` or `../../pkgs`, well you got the hang of it, right?
#
{
  alegreya-sans = import fonts/alegreya-sans.nix;
  alegreya = import fonts/alegreya.nix;
  user-theme = import gnome-shell-exts/user-theme;
  dynamictopbar = import gnome-shell-exts/dynamictopbar.nix;
  shelltile = import gnome-shell-exts/shelltile.nix;
  flat-remix-gnome-theme = import themes/flat-remix-gnome-theme.nix;
}

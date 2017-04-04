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
  cherry-cream-soda = import fonts/cherry-cream-soda.nix;
  kaushan-script = import fonts/kaushan-script.nix;
  kg-miss-speechy-ipa = import fonts/kg-miss-speechy-ipa.nix;
  sansita-one = import fonts/sansita-one.nix;
  user-theme = import gnome-shell-exts/user-theme;
  dynamictopbar = import gnome-shell-exts/dynamictopbar.nix;
  shelltile = import gnome-shell-exts/shelltile.nix;
  flat-remix-gnome-theme = import themes/flat-remix-gnome-theme.nix;
}

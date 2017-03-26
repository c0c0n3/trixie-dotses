# Usage:
#
#   environment.systemPackages = [
#     (import ./pkgs/themes/flat-remix-gnome-theme.nix) ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "flat-remix-gnome-theme";

  theme-name = "Flat Remix";

  src = fetchgit {
    url = https://github.com/daniruiz/Flat-Remix-GNOME-theme.git;
    sha256 = "0ki3wc6phlynf5q34x3np9899v1dg99lb1jngmpmfdk59b2fa65y";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r "${theme-name}" $out/share/themes/
  '';

}

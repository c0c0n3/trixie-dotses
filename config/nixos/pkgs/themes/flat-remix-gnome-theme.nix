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
    rev = "717aab0afe2a5b3f4d97e47874d8c231e6cd2545";
    sha256 = "1bv0x15pdny1n2z1g1n980i5r4wn7ka0hxjwnnd11l5ai8z8a4mr";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/themes
    cp -r "${theme-name}" $out/share/themes/
  '';

}

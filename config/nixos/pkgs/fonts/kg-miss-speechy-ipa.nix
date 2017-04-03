# Usage:
#
#   fonts.fonts = [ (import ./pkgs/fonts/kg-miss-speechy-ipa.nix) ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "kg-miss-speechy-ipa";

  src = fetchurl {
    url = http://www.1001freefonts.com/d/16403/kg_miss_speechy_ipa.zip;
    sha256 = "9b89c315a3093d0ac1b936af08a01d1270c38ed1bc44f80a111b840a871dfe39";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

}

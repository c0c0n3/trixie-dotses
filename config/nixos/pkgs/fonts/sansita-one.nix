# Usage:
#
#   fonts.fonts = [ (import ./pkgs/fonts/sansita-one.nix) ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "sansita-one";

  src = fetchurl {
    url = http://www.1001freefonts.com/d/5774/sansita_one.zip;
    sha256 = "378c438b6ebe91c4a3295dc98589359c403d08856a643f01324b0015fa0f7435";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

}

# Usage:
#
#   fonts.fonts = [ (import ./pkgs/fonts/kaushan-script.nix) ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "kaushan-script";

  src = fetchurl {
    url = http://www.1001freefonts.com/d/4909/kaushan_script.zip;
    sha256 = "5f524d4549990d7f2f6a964d3b4e00825d67839f224393a751ea3a06c5a91c57";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

}

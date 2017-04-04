# Usage:
#
#   fonts.fonts = [ (import ./pkgs/fonts/cherry-cream-soda.nix) ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "cherry-cream-soda";

  src = fetchurl {
    url = http://www.1001freefonts.com/d/5353/cherry_cream_soda.zip;
    sha256 = "31efbadbf39731c81167d91ac50091223a1aeaa1e9c81c23569e874e8465974b";
  };

  buildInputs = [ unzip ];

  sourceRoot = ".";

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

}

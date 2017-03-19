# Usage:
#
#   fonts.fonts = [ (import ./pkgs/fonts/alegreya.nix) ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "alegreya";

  src = fetchgit {
    url = https://github.com/huertatipografica/Alegreya-libre.git;
    sha256 = "1s7s55aynz8gvczyycq410lrslw7rvf97lyhf41ajrmpsaiafms7";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cd otf && cp *.otf $out/share/fonts/opentype
  '';

}

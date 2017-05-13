# Usage:
#
#   fonts.fonts = [ (import ./pkgs/fonts/alegreya.nix) ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "alegreya";

  src = fetchgit {
    url = https://github.com/huertatipografica/Alegreya-libre.git;
    rev = "dc1ff1a287122de3aefb2cf6eda7e4f1de3f9493";
    sha256 = "1s7s55aynz8gvczyycq410lrslw7rvf97lyhf41ajrmpsaiafms7";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cd otf && cp *.otf $out/share/fonts/opentype
  '';

}

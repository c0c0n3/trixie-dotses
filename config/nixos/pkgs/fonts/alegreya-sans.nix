# Usage:
#
#   fonts.fonts = [ (import ./pkgs/fonts/alegreya-sans.nix) ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "alegreya-sans";

  src = fetchgit {
    url = https://github.com/huertatipografica/Alegreya-Sans.git;
    rev = "13c8e819c22dd8df202769b8129046a1f654ebff";
    sha256 = "07101dplh95hbgdn8xlkv8298k70513k1n5g4jng74kwpi78qsvl";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/opentype
    cd otf && cp *.otf $out/share/fonts/opentype
  '';

}

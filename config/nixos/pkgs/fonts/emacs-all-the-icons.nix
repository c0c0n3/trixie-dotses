# Usage:
#
#   fonts.fonts = [ (import ./pkgs/fonts/emacs-all-the-icons.nix) ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "emacs-all-the-icons";

  src = fetchgit {
    url = https://github.com/domtronn/all-the-icons.el.git;
    sha256 = "0kbgznwxh83jr1lg3pqa6nd9lsdjyca3kdmsgiszylvz1d0qlsaj";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp fonts/*.ttf $out/share/fonts/truetype
  '';
}

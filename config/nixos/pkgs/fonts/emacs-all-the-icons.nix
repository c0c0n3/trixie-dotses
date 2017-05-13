# Usage:
#
#   fonts.fonts = [ (import ./pkgs/fonts/emacs-all-the-icons.nix) ];
#
with import <nixpkgs> {};

stdenv.mkDerivation rec {

  name = "emacs-all-the-icons";

  src = fetchgit {
    url = https://github.com/domtronn/all-the-icons.el.git;
    rev = "d070531959036edabc38f39ae8cb1a15608af993";
    sha256 = "1a6j09n0bgxihyql4p49g61zbdwns23pbhb1abphrwn3c2aap2lx";
  };

  phases = [ "unpackPhase" "installPhase" ];

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp fonts/*.ttf $out/share/fonts/truetype
  '';
}

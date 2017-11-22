#
# Installs a LaTeX environment with a smallish set of packages.
# To install more packages in the same environment, use the
# `.with-extra-texlive-pkgs` function.
# This is a quick, hassle-free way to try LaTeX but installs everything
# globally. For development, you're better off using a Nix expression for
# each project you work on, possibly pinning down the nixpkgs version too.
# For ideas and advice on this see:
# - https://github.com/Gabriel439/haskell-nix
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    ext.latex.dev.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Installs LaTeX with a smallish set of packages.
      '';
    };
    ext.latex.dev.with-extra-texlive-pkgs = mkOption {
      # type = ??? no function type in types.nix!
      default = tl: {};
      description = ''
        A function to list additional texlive packages to install over and
        above those we already bring in. Usage:

            with-extra-texlive-pkgs = tl: { inherit (tl) pkg-name-1 pkg-name-2; };

        This module calls the function with 'tl' set to 'textlive',
        so you can list bare package names without 'textlive.' prefix.
      '';
    };
  };

  config =
  let
    cfg = config.ext.latex.dev;

    devBaseSet = with pkgs; {
      inherit (texlive)

      # same as scheme-medium without lang*, context, luatex, texworks, xetex
      collection-basic
      collection-binextra
      collection-fontsrecommended
      collection-fontutils
      collection-genericrecommended
      collection-langenglish
      collection-latex
      collection-latexrecommended
      collection-mathextra
      collection-metapost
      collection-plainextra

      # hand-picked fonts from collection-fontsextra
      alegreya
      eulervm
      fontawesome
      iwona
      sourcecodepro;
    };

    texliveEnv = with pkgs;
      texlive.combine (devBaseSet // (cfg.with-extra-texlive-pkgs texlive));

  in mkIf cfg.enable
  {
    environment.systemPackages = [ texliveEnv ];
  };

}

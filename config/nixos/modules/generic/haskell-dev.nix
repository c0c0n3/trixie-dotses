#
# Installs widely used Haskell libraries and tools as well as `cabal2nix`.
# Specifically, this module installs `cabal2nix` and the latest GHC with
# the following Haskell packages and tools:
#
# - The whole Haskell platform (except for Stack):
#   https://www.haskell.org/platform/contents.html
# - All the libraries recommended by `haskell-lang`:
#   https://haskell-lang.org/libraries
# - The tools needed by the Haskell Spacemacs layer.
# - Some other useful tools: Hakyll, Pandoc, and Shake.
#
# Even though we only explicitly request to install about fifty packages,
# all their dependencies get installed too and registered with GHC, so you
# end up with over 260 packages available to you. (Use `ghc-pkg list` to
# list them all.) To install even more packages in the same environment,
# use the `with-extra-hpkgs` function.
#
# This is a quick, hassle-free way to try Haskell but installs everything
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
    ext.haskell.dev.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Installs a fairly complete Haskell dev environment.
      '';
    };
    ext.haskell.dev.with-extra-hpkgs = mkOption {
      # type = ??? no function type in types.nix!
      default = ps: with ps; [];
      description = ''
        A function to list additional Haskell packages to install over and
        above those we already bring in. Usage:

            with-extra-hpkgs = ps: with ps; [ pkg-name-1 pkg-name-2 ];

        This module calls the function with ps set to 'haskellPackages',
        so you can list bare package names without 'haskellPackages.' prefix.
      '';
    };
  };

  config =
  let
    cfg = config.ext.haskell.dev;

    skip-tests = pkgs.haskell.lib.dontCheck;
    listDevBase = ps: with ps; [
      # Programs and Tools
      # ------------------
      # - Haskell platform tools except for Stack.
      alex cabal-install # haddock # marked as broken in NixOS 19.03!!!
      happy hscolour
      # - needed by Spacemacs Haskell layer and generally useful anyway.
      apply-refact hlint stylish-haskell hasktags hoogle
      # - other tools I've found useful.
      hakyll pandoc pandoc-types shake hpack

      # Libs
      # ----
      # Most of them already get installed as deps of the programs and tools
      # above but list them anyway for the sake of being explicit.

      # - Haskell platform libs.
      async attoparsec call-stack case-insensitive fgl fixed GLURaw GLUT
      half hashable haskell-src html HTTP HUnit integer-logarithms mtl
      network network-uri ObjectName OpenGL OpenGLRaw parallel parsec
      primitive QuickCheck random regex-base regex-compat regex-posix
      scientific split StateVar stm syb text tf-random transformers
      unordered-containers vector zlib

      # - Core libs recommended by haskell-lang but not included in the
      #   Haskell platform.
      aeson criterion optparse-applicative safe-exceptions
      # - Common libs recommended by haskell-lang but not included in the
      #   Haskell platform, excluding hspec and tasty.
      conduit http-client pipes wreq

      # - Tasty framework with the components I've found most useful.
      tasty tasty-hunit tasty-golden tasty-smallcheck tasty-quickcheck
      tasty-html
      (skip-tests tasty-discover)  # for some reason these tests keep on failing
    ];

    listPkgs = ps: (listDevBase ps) ++ (cfg.with-extra-hpkgs ps);

  in mkIf cfg.enable
  {
    environment.systemPackages = with pkgs; [
      cabal2nix
      (haskellPackages.ghcWithPackages listPkgs)
    ];
  };

}

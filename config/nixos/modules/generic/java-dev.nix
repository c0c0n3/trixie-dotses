#
# Installs a Java dev env with Open JDK, Gradle and Intellij Idea.
# Also sets JAVA_HOME globally.
#
{ config, pkgs, lib, ... }:

with lib;
with types;
{

  options = {
    ext.java.dev.enable = mkOption {
      type = bool;
      default = false;
      description = ''
        Installs a Java dev env.
      '';
    };
  };

  config = mkIf config.ext.java.dev.enable
  {
    programs.java.enable = true;  # NOTE (1)
    environment.systemPackages = with pkgs; [
      gradle idea.idea-community
    ];
  };

}
# Notes
# -----
# 1. Java Home. The `java` module install a JDK by default and takes care of
# setting up JAVA_HOME accordingly. Look at their source to see exactly how.
#
# 2. Nix Shell. You may be better off using `nix-shell` to manage dev profiles
# instead of installing globally. E.g. use this Nix expression to get an
# isolated dev env that is the same as the above:
/*

with import <nixpkgs> {}; {
  java-env = stdenv.mkDerivation {
    name = "java-env";
    JAVA_HOME = "${pkgs.jdk.home}/lib/openjdk";

    buildInputs = [ jdk gradle idea.idea-community ];
  };
}

*/
# Assuming you put it in java-dev.nix, you could just
#
#  $ nix-shell java-dev.nix -A java-env
#
# or if you like simple, rename to default.nix, so you can simply run
#
#  $ nix-shell .
#
